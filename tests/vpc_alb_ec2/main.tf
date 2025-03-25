terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "jm-story-terraformstate"
    key            = "dev/terraform/alb.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "jm-story-terraform-state"
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Name    = "jm-story"
      Subject = "jm-story-dev"
    }
  }
}

# 🔹 공통 변수 설정
locals {
  stage       = "dev"
  servicename = "web"
}

module "kms" {
  source       = "../../modules/security/kms"
  stage        = local.stage
  servicename  = "ec2"
  enable_key_rotation = true

  tags = {
    Name = "kms-key-${local.stage}"
  }
}

# 🔹 1. VPC 생성
module "vpc" {
  source   = "../../modules/network/vpc"
  stage    = local.stage
  vpc_cidr = "10.0.0.0/23"
  azs      = ["ap-northeast-2a", "ap-northeast-2b"]
}

# 🔹 2. ALB 생성 (보안 그룹 포함)
module "alb" {
  source                = "../../modules/network/alb"
  stage                 = local.stage
  servicename           = local.servicename
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnet_ids
  instance_ids          = [module.ec2.ec2_id]

  internal              = false
  idle_timeout          = 60
  port                  = 8080
  target_type           = "instance"
  hc_path               = "/health"
  hc_healthy_threshold   = 2
  hc_unhealthy_threshold = 3
  availability_zone     = "all"
  aws_s3_lb_logs_name   = "alb-logs-bucket"
  sg_allow_comm_list    = ["0.0.0.0/0"]

  tags = {
    Name = "aws-alb-${local.stage}-${local.servicename}"
  }
}

# 🔹 3. EC2 인스턴스 생성 (보안 그룹 포함)
module "ec2" {
  source                    = "../../modules/compute/ec2"
  stage                     = local.stage
  servicename               = local.servicename
  ami                       = "ami-0abcd1234abcd1234"
  instance_type             = "t3.micro"
  subnet_id                 = module.vpc.private_subnet_ids[0]
  associate_public_ip       = false
  vpc_id                    = module.vpc.vpc_id
  ec2_port                  = 8080
  ssh_allow_comm_list       = ["0.0.0.0/0"]
  allowed_sg_ids            = [module.alb.sg_alb_id]
  ec2_iam_role_profile_name = module.iam-service-role.ec2_iam_role_profile
  key_name                  = "aws-keypair-${local.stage}-${local.servicename}"
  is_port_forwarding        = false
  kms_key_id                = module.kms.ebs_kms_arn
  ebs_size                  = 20
  user_data                 = "${file("user_data.sh")}"

  tags = {
    Name = "aws-ec2-${local.stage}-${local.servicename}"
  }
}

# 🔹 4. 출력값 설정
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_id" {
  value = module.ec2.ec2_id
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}