variable "zone_name" {
  type        = string
  description = "Route 53 hosted zone name (e.g., example.com)"
}

variable "domain_name" {
  description = "기본 도메인 이름 (예: example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "서브 도메인 목록 (예: www.example.com)"
  type        = list(string)
  default     = []
}