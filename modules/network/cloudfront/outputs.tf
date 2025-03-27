output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.id
}

output "domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.cdn.hosted_zone_id
}

output "oai_iam_arn" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn
}