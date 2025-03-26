variable "stage" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name to connect to CloudFront"
  type        = string
}

variable "s3_origin_domain_name" {
  description = "S3 static website endpoint (e.g. bucket.s3.amazonaws.com)"
  type        = string
}

variable "default_root_object" {
  description = "Default root object for CloudFront"
  type        = string
  default     = "index.html"
}

variable "default_ttl" {
  description = "Default TTL for CloudFront cache"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Max TTL for CloudFront cache"
  type        = number
  default     = 86400
}

variable "use_default_cert" {
  description = "Use CloudFront default SSL cert"
  type        = bool
  default     = true
}

variable "acm_cert_arn" {
  description = "ACM Certificate ARN if using custom domain"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Optional domain name for logging or description"
  type        = string
  default     = ""
}