output "ec2_id" {
  value = aws_instance.ec2.id
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "sg_ec2_id" {
  value = aws_security_group.sg_ec2.id
}