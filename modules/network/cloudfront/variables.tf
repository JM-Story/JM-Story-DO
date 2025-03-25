variable "origin_domain_name" {
  type        = string
  description = "Domain name of the S3 bucket origin (e.g. bucket.s3.amazonaws.com)"
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
}

variable "comment" {
  type        = string
  default     = "CloudFront Distribution"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
