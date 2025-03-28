variable "stage" {
  type = string
  default = "stage"
}
variable "servicename" {
  type = string
  default = "terraform-jm-story"
}
variable "tags" {
  type = map(string)
  default = {
    "Name" = "jm-story"
  }
}