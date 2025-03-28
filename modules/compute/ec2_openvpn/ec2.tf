resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn-sg-${var.stage}"
  description = "Allow OpenVPN traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "openvpn-sg-${var.stage}"
  }
}

resource "aws_instance" "openvpn" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.openvpn_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "openvpn-${var.stage}"
  }
}

resource "aws_eip" "openvpn_eip" {
  instance = aws_instance.openvpn.id
}