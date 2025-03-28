resource "aws_iam_role" "ec2_iam_role" {
  name = "aws-iam-${var.stage}-${var.servicename}-ec2-role"

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

  tags = {
    Subject = "jm-story"
  }
}

resource "aws_iam_instance_profile" "ec2_iam_role_profile" {
  name = "aws-iam-${var.stage}-${var.servicename}-ec2-role-profile"
  role = aws_iam_role.ec2_iam_role.name
}

# 🔹 ECR Pull 권한
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 🔹 CodeDeploy Agent 배포 권한
resource "aws_iam_role_policy_attachment" "codedeploy_agent" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

# 🔹 SSM Parameter Read 권한
resource "aws_iam_role_policy_attachment" "ssm_readonly" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}