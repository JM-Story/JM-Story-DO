resource "aws_kms_key" "rds-kms-key" {
  description             = "This key is used to encrypt rds ${var.stage}-${var.servicename}"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  tags = merge(tomap({
         name = "aws-kms-${var.stage}-${var.servicename}-rds"}),
         var.tags)
}

resource "aws_kms_alias" "rds-comm-kms-key-alias" {
  name          = "alias/aws-kms-${var.stage}-${var.servicename}-rds"
  target_key_id = aws_kms_key.rds-kms-key.key_id
}

resource "aws_kms_key" "ebs_kms_key" {
  description             = "This key is used to encrypt EBS ${var.stage}-${var.servicename}"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  tags = merge(tomap({
         name = "aws-kms-${var.stage}-${var.servicename}-ebs"}),
         var.tags)
}

resource "aws_kms_alias" "ebs_kms_alias" {
  name          = "alias/aws-kms-${var.stage}-${var.servicename}-ebs"
  target_key_id = aws_kms_key.ebs_kms_key.key_id
}