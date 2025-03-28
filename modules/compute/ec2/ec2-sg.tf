resource "aws_security_group" "sg_ec2" {
  name   = "aws-sg-${var.stage}-${var.servicename}-ec2"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.ec2_port
    to_port         = var.ec2_port
    protocol        = "TCP"
    security_groups = var.allowed_sg_ids
    description     = "Allow traffic from ALB"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = var.ssh_allow_comm_list
    description = "Allow SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    name = "aws-sg-${var.stage}-${var.servicename}-ec2"
  }, var.tags)
}