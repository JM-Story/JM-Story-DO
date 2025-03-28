resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg-${var.stage}"
  description = "Security group for MySQL RDS"
  vpc_id      = var.vpc_id

  # MySQL 포트(3306) 허용 (VPC 내부 또는 특정 CIDR 허용)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  # 아웃바운드 트래픽은 모두 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "mysql-sg-${var.stage}"
  }
}