resource "aws_s3_bucket" "static" {
  bucket = var.bucket_name
  tags = {
    Name = "static-site-${var.stage}"
  }
}

resource "aws_s3_bucket_website_configuration" "static" {
  bucket = aws_s3_bucket.static.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "static_block" {
  bucket = aws_s3_bucket.static.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}
