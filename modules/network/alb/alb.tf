# ALB 생성
resource "aws_lb" "alb" {
  name               = "aws-alb-${var.stage}-${var.servicename}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = var.subnet_ids
  enable_deletion_protection = false
  idle_timeout       = var.idle_timeout

  tags = merge(
    {
      name = "aws-alb-${var.stage}-${var.servicename}"
    },
    var.tags
  )
}

# Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "aws-alb-tg-${var.stage}-${var.servicename}"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    path                = var.hc_path
    healthy_threshold   = var.hc_healthy_threshold
    unhealthy_threshold = var.hc_unhealthy_threshold
  }

  tags = merge(
    {
      name = "aws-alb-tg-${var.stage}-${var.servicename}"
    },
    var.tags
  )
}

# HTTP 리스너 → EC2 바로 포워딩 (HTTPS 없이)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = var.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = var.tags
}

# EC2 Target Group Attachment
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count              = length(var.instance_ids)
  target_group_arn   = aws_lb_target_group.target_group.arn
  target_id          = var.instance_ids[count.index]
  port               = var.port
}