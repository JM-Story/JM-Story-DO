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

module "s3" {
  source          = "../../modules/storage/s3_web"
  stage           = "dev"
  bucket_name     = "jm-story-frontend-dev"
  index_document  = "index.html"
  error_document  = "error.html"
} 

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3.bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowCloudFrontOAI",
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "arn:aws:s3:::${module.s3.bucket_name}/*",
        Principal = {
          AWS = module.cloudfront.oai_iam_arn
        }
      }
    ]
  })

  depends_on = [module.cloudfront.oai_iam_arn]
}

module "acm" {
  source = "../../modules/security/acm"

  domain_name               = "jm-story.site"
  subject_alternative_names = ["www.jm-story.site"]
}

module "cloudfront" {
  source                 = "../../modules/network/cloudfront"
  stage                  = "dev"
  bucket_name            = module.s3.bucket_name
  s3_origin_domain_name  = module.s3.bucket_regional_domain_name
  acm_cert_arn           = module.acm.cert_arn
  default_root_object    = "index.html"
  use_default_cert       = true
  domain_name            = "jm-story.site"
  depends_on             = [module.acm]
}

module "route53" {
  source    = "../../modules/network/route53"
  zone_name = "jm-story.site"

  records = [
    {
      name           = "jm-story.site"
      type           = "A"
      alias_name     = module.cloudfront.domain_name
      alias_zone_id  = module.cloudfront.hosted_zone_id
      evaluate_target_health = false
    }
  ]
}