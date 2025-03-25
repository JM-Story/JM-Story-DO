terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "jm-story-terraformstate"
    key  = "dev/terraform/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "jm-story-terraform-state"
  }
}


provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Name     = "jm-story"
      Subject  = "jm-story-dev"
    }
  }
}

# VPC 모듈 호출
module "vpc" {
  source          = "../../modules/network/vpc"
  stage           = "dev"
  vpc_cidr        = "10.0.0.0/23"
  azs             = ["ap-northeast-2a", "ap-northeast-2b"]
}

# VPC 출력값 출력
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "db_subnet_group" {
  value = module.vpc.db_subnet_group
}