variable "stage" {}
variable "servicename" {}
variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "associate_public_ip" { type = bool }
variable "ec2_port" { type = number }
variable "ssh_allow_comm_list" { type = list(string) }
variable "allowed_sg_ids" { type = list(string) }
variable "ec2_iam_role_profile_name" {}
variable "key_name" {}
variable "is_port_forwarding" { type = bool }
variable "kms_key_id" {}
variable "ebs_size" { type = number }
variable "user_data" {}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "vpc_id" {}