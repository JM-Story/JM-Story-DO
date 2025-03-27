variable "stage" {
  description = "Stage (e.g. dev, prod)"
  type        = string
}

variable "servicename" {
  description = "Service name used for tagging and naming"
  type        = string
}

variable "ami" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be created"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to assign public IP"
  type        = bool
  default     = false
}

variable "ec2_port" {
  description = "Application port to allow (e.g. 8080)"
  type        = number
}

variable "ssh_allow_comm_list" {
  description = "List of CIDRs allowed to SSH"
  type        = list(string)
  default     = []
}

variable "allowed_sg_ids" {
  description = "Security group IDs that are allowed to access EC2"
  type        = list(string)
}

variable "ec2_iam_role_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "is_port_forwarding" {
  description = "Whether to enable port forwarding (NAT usage)"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key ARN to encrypt EBS volume"
  type        = string
}

variable "ebs_size" {
  description = "Size of EBS volume in GB"
  type        = number
  default     = 8
}

variable "user_data" {
  description = "User data script to run at launch"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EC2 and security group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}