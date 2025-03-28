variable "stage" {
  type    = string
  default = "dev"
}

variable "bucket_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type = list(string)
  default = []
}

variable "certificate_arn" {
  type        = string
  description = "ARN of ACM certificate for ALB"
}