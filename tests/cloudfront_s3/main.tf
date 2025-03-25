module "s3" {
  source      = "../../modules/storage/s3"
  bucket_name = "jm-story-dev"
  acl         = "private"
  versioning  = true
  tags = {
    Project = "jm-story"
  }
}

module "cdn" {
  source             = "../../modules/network/cloudfront"
  origin_domain_name = module.s3.bucket_domain_name
  comment            = "Frontend CDN"
  tags = {
    Project = "jm-story"
  }
}