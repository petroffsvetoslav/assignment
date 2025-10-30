resource "aws_lb_target_group" "app_tg" {
  name        = "${var.name}-${var.env}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 4
    unhealthy_threshold = 3
  }

  tags = merge(
    {
      Name = "${var.name}-${var.env}-tg"
    }
  )
}