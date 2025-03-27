module "s3" {
  source          = "../../../modules/storage/s3_web"
  stage           = var.stage
  bucket_name     = var.bucket_name
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
  source = "../../../modules/security/acm"

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
}

module "cloudfront" {
  source                 = "../../../modules/network/cloudfront"
  stage                  = var.stage
  bucket_name            = module.s3.bucket_name
  s3_origin_domain_name  = module.s3.bucket_regional_domain_name
  acm_cert_arn           = module.acm.cert_arn
  default_root_object    = "index.html"
  use_default_cert       = true
  domain_name            = var.domain_name
  depends_on             = [module.acm]
}

module "route53" {
  source    = "../../../modules/network/route53"
  zone_name = var.domain_name

  records = [
    {
      name           = var.domain_name
      type           = "A"
      alias_name     = module.cloudfront.domain_name
      alias_zone_id  = module.cloudfront.hosted_zone_id
      evaluate_target_health = false
    }
  ]
}