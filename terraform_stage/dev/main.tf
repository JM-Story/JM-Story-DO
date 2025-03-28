terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket         = "jm-story-terraformstate"
    key            = "dev/terraform/main.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "jm-story-terraformstate"
  }
}

provider "aws" {
  alias  = "seoul"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

module "acm_seoul" {
  source = "../../modules/security/acm"

  providers = {
    aws = aws.seoul
  }

  zone_name                 = local.domain_name
  domain_name               = "${local.stage}-api.${local.domain_name}"
  subject_alternative_names = ["www.${local.stage}-api.${local.domain_name}"]
}

module "acm_virginia" {
  source = "../../modules/security/acm"

  providers = {
    aws = aws.virginia
  }
  zone_name                 = local.domain_name
  domain_name               = local.domain_name
  subject_alternative_names = local.subject_alternative_names
}

locals {
  stage        = "dev"
  servicename  = "web"
  domain_name  = "jm-story.site"
  subject_alternative_names = ["www.jm-story.site"]
}

# 🔹 VPC 생성
module "vpc" {
  source   = "../../modules/network/vpc"
  stage    = local.stage
  vpc_cidr = "10.0.0.0/23"
  azs      = ["ap-northeast-2a", "ap-northeast-2b"]
}

module "openvpn" {
  source        = "../../modules/compute/ec2_openvpn"
  ami_id        = "ami-09a093fa2e3bfca5a"
  stage         = local.stage
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  key_name      = "jm-admin"
  allowed_cidrs = ["0.0.0.0/0"]
}

# 🔹 Frontend 모듈로 S3 + CloudFront 배포
module "frontend" {
  source = "../../envs/dev/frontend"

  stage       = local.stage
  bucket_name = "jm-story-frontend-dev"
  domain_name = local.domain_name
  subject_alternative_names = local.subject_alternative_names
  certificate_arn = module.acm_virginia.certificate_arn
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "ecr" {
  source = "../../modules/storage/ecr"

  name = "jm-story-be"
  tags = {
    Stage = local.stage
  }
}

# 🔹 Backend 모듈로 ALB, EC2, RDS 생성
module "backend" {
  source = "../../envs/dev/backend"

  stage        = local.stage
  servicename  = local.servicename
  domain_name  = local.domain_name
  certificate_arn = module.acm_seoul.certificate_arn

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids

  kms_key_id                = module.kms.ebs_kms_arn

  ami                       = "ami-0c9c942bd7bf113a2"
  instance_type             = "t3.micro"
  ec2_iam_role_profile_name = module.iam-service-role.ec2_iam_role_profile_name
  ebs_size                  = 30
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    region     = data.aws_region.current.name
    account_id = data.aws_caller_identity.current.account_id
  })

  db_username               = "js_admin"
  db_password               = "wjdalsdk0513"
  db_subnet_group           = module.vpc.db_subnet_group
  
  depends_on = [module.vpc, module.frontend]
}

module "codedeploy" {
  source      = "../../modules/cicd/codedeploy"
  project     = "jm-story"
  stage       = local.stage
  servicename = local.servicename
  tags = {
    Environment = local.stage
    Project     = "jm-story"
  }
}

module "s3_deploy_bucket" {
  source        = "../../modules/storage/s3_storage"
  bucket_name   = "jm-story-deploy-artifact-${local.stage}"
  force_destroy = true
  versioning    = true

  tags = {
    Name        = "jm-story-deploy-${local.stage}"
    Environment = local.stage
  }
}

module "ssm_parameters" {
  source = "../../modules/storage/ssm_parameter"

  parameters = [
    {
      name  = "/jm-story/${local.stage}/RDS_ENDPOINT"
      value = module.backend.rds_endpoint
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/ALB_DNS"
      value = module.backend.alb_dns
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/EC2_ID"
      value = module.backend.ec2_id
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/S3_BUCKET"
      value = module.frontend.s3_bucket_name
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/CLOUDFRONT_ID"
      value = module.frontend.cloudfront_distribution_id
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/ECR_REPO_URL"
      value = module.ecr.repository_url
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/CODEDEPLOY_APP"
      value = module.codedeploy.app_name
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/CODEDEPLOY_GROUP"
      value = module.codedeploy.deployment_group_name
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/S3_DEPLOY_BUCKET"
      value = module.s3_deploy_bucket.bucket_name
      type  = "String"
    },
    {
      name  = "/jm-story/${local.stage}/DATABASE_URL"
      value = "mysql+pymysql://js_admin:wjdalsdk0513@${module.backend.rds_endpoint}/webdb"
      type  = "String"
    }
  ]

  depends_on = [module.backend, module.frontend, module.ecr, module.codedeploy, module.s3_deploy_bucket]
}
