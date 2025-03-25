output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.this.id
}

output "oai_iam_arn" {
  value = aws_cloudfront_origin_access_identity.this.iam_arn
}