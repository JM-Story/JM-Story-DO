resource "aws_iam_role" "ec2_iam_role" {
  name ="aws-iam-${var.stage}-${var.servicename}-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = var.tags

}

resource "aws_iam_instance_profile" "ec2_iam_role_profile" {
  name = "aws-iam-${var.stage}-${var.servicename}-ec2-role-profile"
  role = aws_iam_role.ec2_iam_role.name
}