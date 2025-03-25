output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_oai" {
  description = "Origin Access Identity path"
  value       = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}