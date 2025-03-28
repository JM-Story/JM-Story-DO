# 공통 환경 변수
variable "stage" {
  description = "Deployment stage (dev, prod, etc.)"
  type        = string
}

# MySQL 설정
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage size (GB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage size (GB)"
  type        = number
  default     = 100
}

variable "username" {
  description = "Master database username"
  type        = string
}

variable "password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "parameter_group" {
  description = "Database parameter group"
  type        = string
  default     = "default.mysql8.0"
}

variable "kms_key_arn" {
  description = "KMS key for encryption"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group ID for MySQL"
  type        = string
}

variable "db_subnet_group" {
  description = "DB Subnet Group name"
  type        = string
}

variable "publicly_accessible" {
  description = "Allow public access to the database"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

# MySQL 보안 그룹 관련 변수
variable "vpc_id" {
  description = "VPC ID where MySQL security group will be created"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks for MySQL access"
  type        = list(string)
  default     = ["10.0.0.0/16"]  # 기본값: 내부 VPC에서만 접근 가능
}