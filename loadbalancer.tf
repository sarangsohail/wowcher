resource "aws_lb" "ecs" {
  name               = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_service_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "ecs-lb"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.ecs.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ecs" {
  name_prefix       = "ecs-tg"
  port              = var.app_container_port
  protocol          = "HTTP"
  target_type       = "ip"
  vpc_id            = var.vpc_id

  health_check {
    path               = "/healthcheck"
    interval           = 30
    timeout            = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}