variable "domain_name" {
  description = "기본 도메인 이름 (예: example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "서브 도메인 목록 (예: www.example.com)"
  type        = list(string)
  default     = []
}