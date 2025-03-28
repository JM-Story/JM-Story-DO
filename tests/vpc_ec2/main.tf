terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "jm-story-terraformstate"
    key            = "dev/terraform/ec2.tfstate"
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

# 🔹 VPC 및 서브넷 모듈 호출
module "vpc" {
  source   = "../../modules/network/vpc"
  stage    = "dev"
  vpc_cidr = "10.0.0.0/23"
  azs      = ["ap-northeast-2a", "ap-northeast-2b"]
}

# 🔹 Private Subnet 중 첫 번째 서브넷 선택
data "aws_subnet" "private_subnet" {
  id = module.vpc.private_subnet_ids[0]  # private-subnet-1-dev
}

locals {
  vpc_id        = module.vpc.vpc_id
  subnet_id     = data.aws_subnet.private_subnet.id
}

# 🔹 EC2 인스턴스용 보안 그룹 생성
resource "aws_security_group" "sg-ec2" {
  name        = "aws-sg-${var.stage}-${var.servicename}-ec2"
  description = "Security Group for EC2 Instance"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = var.ssh_allow_comm_list  # SSH 접근 허용 CIDR
    description = "Allow SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "aws-sg-${var.stage}-${var.servicename}-ec2"
  }
}

# 🔹 EC2 인스턴스 생성 (Private Subnet 내)
resource "aws_instance" "ec2" {
  ami                     = var.ami
  instance_type           = var.instance_type
  subnet_id               = local.subnet_id  # private-subnet-1-dev
  vpc_security_group_ids  = [aws_security_group.sg-ec2.id]
  associate_public_ip_address = false  # Private Subnet 내 배포이므로 퍼블릭 IP 없음

  iam_instance_profile    = var.ec2_iam_role_profile_name
  key_name                = "aws-keypair-${var.stage}-${var.servicename}" 
  source_dest_check       = !var.isPortForwarding

  root_block_device {
    delete_on_termination = false
    encrypted = true
    kms_key_id = var.kms_key_id
    volume_size = var.ebs_size
  }

  user_data = var.user_data

  tags = {
    name = "aws-ec2-${var.stage}-${var.servicename}"
  }

  lifecycle {
    ignore_changes = [user_data, associate_public_ip_address]
  }
}

# 🔹 출력값 설정
output "ec2_id" {
  value = aws_instance.ec2.id
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "subnet_id" {
  value = local.subnet_id
}