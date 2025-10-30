resource "aws_instance" "temp" {
  ami           = var.source_ami_id
  instance_type = var.instance_type
  ebs_optimized = true
  subnet_id     = "xxx"
  key_name      = var.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
  tags = merge(
    {
      Name = "${var.name}-${var.env}"
    }
  )
}

resource "aws_ami_from_instance" "nginx_ami" {
  name               = "${var.name}-${var.env}"
  source_instance_id = aws_instance.temp.id
  depends_on         = [aws_instance.temp]
  tags = merge(
    {
      Name = "${var.name}-${var.env}"
    }
  )
}
