variable "stage" {
  description = "Deployment stage"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "S3 bucket name for frontend static hosting"
  type        = string
  default     = "jm-story-frontend-dev"
}

variable "index_document" {
  description = "Default document for S3 static website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for S3 static website"
  type        = string
  default     = "error.html"
}

variable "use_default_cert" {
  description = "Whether to use CloudFront default SSL cert"
  type        = bool
  default     = true
}

variable "acm_cert_arn" {
  description = "ACM certificate ARN (if using custom domain)"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name for CloudFront distribution"
  type        = string
  default     = "dev.example.com"
}