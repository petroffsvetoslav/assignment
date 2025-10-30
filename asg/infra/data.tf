data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_elb_policy" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeLoadBalancers"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ec2_elb_policy_2" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_id}:targetgroup/${var.name}-${var.env}/*"
    ]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["self "]
  filter {
    name = "${var.name}-${var.env}"
  }
}