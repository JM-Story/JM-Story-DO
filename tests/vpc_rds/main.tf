terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "jm-story-terraformstate"
    key            = "dev/terraform/terraform.tfstate"
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

# 🔹 VPC 모듈 생성
module "vpc" {
  source   = "../../modules/network/vpc"
  stage    = "dev"
  vpc_cidr = "10.0.0.0/23"
  azs      = ["ap-northeast-2a", "ap-northeast-2b"]
}

# 🔹 KMS 모듈 호출 (RDS 암호화를 위한 KMS 키 생성)
module "kms" {
  source       = "../../modules/security/kms"
  stage        = "dev"
  servicename  = "rds"
  enable_key_rotation = true

  tags = {
    Name        = "kms-rds-dev"
    Environment = "dev"
    Service     = "rds"
  }
}

# 🔹 보안 그룹 생성 (MySQL RDS)
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg-${module.vpc.vpc_id}"
  description = "Security group for MySQL RDS"
  vpc_id      = module.vpc.vpc_id

  # MySQL (3306) 포트 허용 (VPC 내부에서만 접근 가능)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/23"]  # 내부 VPC에서만 접근 허용
  }

  # 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "mysql-sg-${module.vpc.vpc_id}"
  }
}

# 🔹 MySQL RDS 서브넷 그룹 생성
resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids

  tags = {
    name = "mysql-subnet-group"
  }
}

# 🔹 MySQL RDS 생성 (KMS 모듈에서 키 가져오기)
resource "aws_db_instance" "mysql" {
  identifier              = "dev-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_name                 = "jsdb_dev"
  username                = "js_admin"
  password                = "wjdalsdk0513"
  parameter_group_name    = "default.mysql8.0"
  storage_encrypted       = true
  kms_key_id              = module.kms.rds_kms_arn
  vpc_security_group_ids  = [aws_security_group.mysql_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.mysql.name
  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true

  tags = {
    name = "mysql-dev"
  }
}

# 🔹 출력값 설정
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "rds_kms_arn" {
  value = module.kms.rds_kms_arn
}

output "mysql_endpoint" {
  value = aws_db_instance.mysql.endpoint
}