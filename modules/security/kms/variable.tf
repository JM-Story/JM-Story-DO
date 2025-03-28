variable "servicename" {
  type =string
}
variable "stage" {
  type =string
}
variable "tags" {
  type = map(string)
}
variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}