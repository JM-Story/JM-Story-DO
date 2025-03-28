resource "aws_ssm_parameter" "parameters" {
  for_each = { for param in var.parameters : param.name => param }

  name        = each.value.name
  description = lookup(each.value, "description", null)
  type        = lookup(each.value, "type", "SecureString")
  value       = each.value.value
  tier        = lookup(each.value, "tier", "Standard")

  tags = lookup(each.value, "tags", {})
}