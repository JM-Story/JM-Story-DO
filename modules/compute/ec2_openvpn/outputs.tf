output "openvpn_instance_id" {
  value = aws_instance.openvpn.id
}

output "openvpn_public_ip" {
  value = aws_eip.openvpn_eip.public_ip
}

output "openvpn_sg_id" {
  value = aws_security_group.openvpn_sg.id
}