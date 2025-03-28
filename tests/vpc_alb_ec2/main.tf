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

module "iam-service-role" {
  source = "../../modules/security/iam/iam-service-role"
  stage = var.stage
  servicename = var.servicename
  tags = var.tags  
}

module "kms" {
  source       = "../../modules/security/kms"
  stage        = local.stage
  servicename  = "ec2"
  enable_key_rotation = true

  tags = {
    name = "kms-key-${local.stage}"
  }
}

# 🔹 1. VPC 생성
module "vpc" {
  source   = "../../modules/network/vpc"
  stage    = local.stage
  vpc_cidr = "10.0.0.0/23"
  azs      = ["ap-northeast-2a", "ap-northeast-2b"]
}

resource "aws_security_group" "alb_to_ec2" {
  name        = "alb-to-ec2"
  description = "Allow traffic from ALB to EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow ALB to access EC2"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔹 3. EC2 인스턴스 생성 (보안 그룹 포함)
module "ec2" {
  source                    = "../../modules/compute/ec2"
  stage                     = local.stage
  servicename               = local.servicename
  ami                       = "ami-0c9c942bd7bf113a2"
  instance_type             = "t3.micro"
  subnet_id                 = module.vpc.private_subnet_ids[0]
  associate_public_ip       = false
  vpc_id                    = module.vpc.vpc_id
  ec2_port                  = 8000
  ssh_allow_comm_list       = ["0.0.0.0/0"]
  allowed_sg_ids            = [aws_security_group.alb_to_ec2.id]
  ec2_iam_role_profile_name = module.iam-service-role.ec2_iam_role_profile_name
  key_name                  = "jm-admin"
  is_port_forwarding        = false
  kms_key_id                = module.kms.ebs_kms_arn
  ebs_size                  = 20
  user_data                 = "${file("user_data.sh")}"

  tags = {
    name = "aws-ec2-${local.stage}-${local.servicename}"
  }
}

module "alb" {
  source                = "../../modules/network/alb"
  stage                 = local.stage
  servicename           = local.servicename
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnet_ids
  instance_ids          = [module.ec2.ec2_id]

  internal              = false
  idle_timeout          = 60
  port                  = 8000
  target_type           = "instance"
  hc_path               = "/health"
  hc_healthy_threshold   = 2
  hc_unhealthy_threshold = 3
  sg_allow_comm_list    = ["0.0.0.0/0"]

  tags = {
    name = "aws-alb-${local.stage}-${local.servicename}"
  }

  depends_on = [module.ec2]
}

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