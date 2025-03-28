output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "sg_alb_id" {
  value = aws_security_group.sg_alb.id
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}