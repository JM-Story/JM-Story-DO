variable "stage" {
  type        = string
  description = "Environment stage (e.g. dev, prod)"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "index_document" {
  type        = string
  default     = "index.html"
}

variable "error_document" {
  type        = string
  default     = "error.html"
}