variable "project" {}
variable "stage" {}
variable "servicename" {}
variable "tags" {
  type    = map(string)
  default = {}
}