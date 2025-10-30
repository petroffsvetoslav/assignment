resource "aws_launch_template" "app_lt" {
  name          = "${var.name}-${var.env}"
  image_id      = data.aws_ami.amazon_linux.id # see data block below
  instance_type = var.instance_type

  key_name = var.key_name

  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tags = merge(
    {
      Name = "${var.name}-${var.env}-lt"
    }
  )
}