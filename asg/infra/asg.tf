resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.name}-${var.env}"
  max_size            = 2
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  termination_policies = ["OldestInstance"]

  tags = merge(
    {
      Name = "${var.name}-${var.env}-tg"
    }
  )
}