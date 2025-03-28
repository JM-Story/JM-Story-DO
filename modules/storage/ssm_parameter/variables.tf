variable "parameters" {
  type = list(object({
    name        = string
    value       = string
    type        = optional(string, "SecureString")
    description = optional(string)
    tier        = optional(string, "Standard")
    tags        = optional(map(string), {})
  }))
}