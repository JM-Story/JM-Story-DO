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

# variable "index_document" {
#   type    = string
#   default = "index.html"
# }

# variable "error_document" {
#   type    = string
#   default = "error.html"
# }