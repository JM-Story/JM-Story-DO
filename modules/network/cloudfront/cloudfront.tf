resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = var.default_root_object
  comment             = "CloudFront for ${var.stage} - ${var.domain_name}"

  origin {
    domain_name = var.s3_origin_domain_name
    origin_id   = "S3-${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.use_default_cert
    acm_certificate_arn            = var.acm_cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = {
    Environment = var.stage
    Name        = "cloudfront-${var.stage}"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.stage} CloudFront"
}
