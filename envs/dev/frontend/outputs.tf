output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "cloudfront_domain_name" {
  value = module.cloudfront.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = module.cloudfront.hosted_zone_id
}

output "acm_cert_arn" {
  value = module.acm.cert_arn
}