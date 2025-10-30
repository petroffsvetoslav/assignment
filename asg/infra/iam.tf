resource "aws_iam_role" "ec2_role" {
  name               = "${var.name}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_policy" "ec2_elb_policy" {
  name   = "${var.name}-${var.env}"
  policy = data.aws_iam_policy_document.ec2_elb_policy.json
}

resource "aws_iam_policy" "ec2_elb_policy_2" {
  name   = "${var.name}-${var.env}-2"
  policy = data.aws_iam_policy_document.ec2_elb_policy_2.json
}

resource "aws_iam_role_policy_attachment" "attach_elb" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_elb_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_elb_2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_elb_policy_2.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.name}-${var.env}"
  role = aws_iam_role.ec2_role.name
}