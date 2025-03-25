module "s3" {
  source         = "../../../modules/storage/s3"
  stage          = "dev"
  bucket_name    = "jm-story-frontend-dev"
  index_document = "index.html"
  error_document = "error.html"
}

module "cloudfront" {
  source                 = "../../../modules/storage/cloudfront"
  stage                  = "dev"
  bucket_name            = module.s3.bucket_name
  s3_origin_domain_name  = module.s3.bucket_regional_domain_name
  default_root_object    = "index.html"
  use_default_cert       = true
  acm_cert_arn           = ""
  domain_name            = "dev.example.com"
}