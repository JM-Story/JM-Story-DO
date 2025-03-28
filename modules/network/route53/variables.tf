variable "zone_name" {
  type        = string
  description = "Route 53 Hosted Zone name (e.g., example.com)"
}

variable "records" {
  type = list(object({
    name                   = string
    type                   = string
    ttl                    = optional(number)
    records                = optional(list(string))
    alias_name             = optional(string)
    alias_zone_id          = optional(string)
    evaluate_target_health = optional(bool, false)
  }))

  description = "List of DNS records to create"
}

variable "acm_records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = list(string)
  }))

  default     = []
  description = "ACM certificate DNS validation records"
}