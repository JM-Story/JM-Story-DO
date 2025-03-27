variable "stage" {}
variable "servicename" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "instance_ids" { type = list(string) }
variable "internal" { type = bool }
variable "idle_timeout" { type = number }
variable "port" { type = number }
variable "target_type" {}
variable "hc_path" {}
variable "hc_healthy_threshold" { type = number }
variable "hc_unhealthy_threshold" { type = number }
variable "sg_allow_comm_list" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}