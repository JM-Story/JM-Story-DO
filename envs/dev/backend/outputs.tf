output "alb_dns" {
  value = module.alb.alb_dns_name
}

output "ec2_id" {
  value = module.ec2.ec2_id
}

output "rds_endpoint" {
  value = module.rds.mysql_endpoint
}