output "ssm_parameter_names" {
  value = [for p in aws_ssm_parameter.parameters : p.name]
}