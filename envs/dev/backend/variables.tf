variable "stage" { type = string }
variable "servicename" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }

variable "ami" { type = string }
variable "instance_type" { type = string }
variable "ec2_iam_role_profile_name" { type = string }
variable "kms_key_id" { type = string }
variable "ebs_size" { type = number }
variable "user_data" { type = string }

variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_subnet_group" { type = string }

variable "domain_name" { type = string }
variable "certificate_arn" {
  type        = string
  description = "ARN of ACM certificate for ALB"
}