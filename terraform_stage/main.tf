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
    dynamodb_table = "jm-story-terraform-state"
  }
}

locals {
  stage        = "dev"
  servicename  = "web"
}

# 🔹 VPC 생성
module "vpc" {
  source   = "../modules/network/vpc"
  stage    = local.stage
  vpc_cidr = "10.0.0.0/23"
  azs      = ["ap-northeast-2a", "ap-northeast-2b"]
}

# 🔹 Frontend 모듈로 S3 + CloudFront 배포
module "frontend" {
  source = "../envs/dev/frontend"

  stage       = local.stage
  bucket_name = "jm-story-frontend-${local.stage}"
  domain_name = "dev.example.com"
}


# 🔹 Backend 모듈로 ALB, EC2, RDS 생성
module "backend" {
  source = "../envs/dev/backend"

  stage        = local.stage
  servicename  = local.servicename

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids

  kms_key_id                = module.kms.ebs_kms_arn
  ami                       = "ami-0abcd1234abcd1234"
  instance_type             = "t3.micro"
  ec2_iam_role_profile_name = module.iam-service-role.ec2_iam_role_profile_name
  ebs_size                  = 30
  user_data                 = "ls"

  db_username               = "js_admin"
  db_password               = "wjdalsdk0513"
  db_subnet_group           = module.vpc.db_subnet_group
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns" {
  value = module.backend.alb_dns
}

output "ec2_id" {
  value = module.backend.ec2_id
}

output "rds_endpoint" {
  value = module.backend.rds_endpoint
}