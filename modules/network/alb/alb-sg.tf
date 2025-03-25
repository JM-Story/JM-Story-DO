resource "aws_security_group" "sg_alb" {
  name   = "aws-sg-${var.stage}-${var.servicename}-alb"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.sg_allow_comm_list
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.sg_allow_comm_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "aws-sg-${var.stage}-${var.servicename}-alb" }, var.tags)
}

resource "aws_security_group" "sg_alb_to_tg" {
  name   = "aws-sg-${var.stage}-${var.servicename}-alb-to-tg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "TCP"
    security_groups = [aws_security_group.sg_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "aws-sg-${var.stage}-${var.servicename}-alb-to-tg" }, var.tags)
}