# output "eks_kms_arn" {
#   value =aws_kms_key.eks-kms-key.arn
# }
output "rds_kms_arn" {
  value = aws_kms_key.rds-kms-key.arn
}
output "rds_kms_id" {
  value = aws_kms_key.rds-kms-key.id
}
output "ebs_kms_arn" {
  value = aws_kms_key.ebs_kms_key.arn
}
output "ebs_kms_id" {
  value = aws_kms_key.ebs_kms_key.id
}
# output "ssm_parameter_kms_arn" {
#   value =aws_kms_key.ssm-parameter-kms-key.arn
# }