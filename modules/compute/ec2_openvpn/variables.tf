variable "stage" {
  type        = string
  description = "Deployment stage"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch OpenVPN instance"
}

variable "ami_id" {
  type        = string
  description = "AMI ID (Ubuntu 추천)"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDRs allowed to access OpenVPN (port 1194)"
}