resource "aws_db_instance" "mysql" {
  identifier              = lower("${var.stage}${var.db_name}")
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group
  storage_encrypted      = true
  kms_key_id             = var.kms_key_arn
  vpc_security_group_ids = [var.mysql_sg_id]
  db_subnet_group_name   = var.db_subnet_group
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  skip_final_snapshot    = true

  tags = merge(
    {
      Name = "mysql-${var.stage}-${var.db_name}"
    },
    var.tags
  )
}
