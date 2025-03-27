variable "project" {
  description = "Project or service name"
  type        = string
}

variable "tag_key" {
  type        = string
  description = "EC2 tag key to match for deployment"
}

variable "tag_value" {
  type        = string
  description = "EC2 tag value to match for deployment"
}

variable "autoscaling_groups" {
  type        = list(string)
  description = "ASG names to deploy to"
  default     = []
}

variable "elb_name" {
  type        = string
  description = "Name of the ELB connected to ASG"
  default     = ""
}