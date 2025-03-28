output "mysql_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "mysql_instance_id" {
  value = aws_db_instance.mysql.id
}

output "mysql_arn" {
  value = aws_db_instance.mysql.arn
}

output "mysql_sg_id" {
  value = aws_security_group.mysql_sg.id
}