variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "versioning" {
  type        = bool
  default     = false
  description = "Whether to enable versioning"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to force destroy the bucket on terraform destroy"
}

variable "tags" {
  type    = map(string)
  default = {}
}