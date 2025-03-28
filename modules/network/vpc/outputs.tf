output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat_gw[*].id
}

output "nat_eip_addresses" {
  value = aws_eip.nat_eip[*].public_ip
}