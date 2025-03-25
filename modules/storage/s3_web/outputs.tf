output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}