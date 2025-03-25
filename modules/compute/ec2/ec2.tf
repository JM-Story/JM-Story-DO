resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = var.ec2_iam_role_profile_name
  key_name                    = var.key_name
  source_dest_check           = !var.is_port_forwarding
  vpc_security_group_ids      = [aws_security_group.sg_ec2.id]

  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    delete_on_termination = false
    encrypted             = true
    kms_key_id            = var.kms_key_id
    volume_size           = var.ebs_size
  }

  user_data = var.user_data

  tags = merge({
    Name = "aws-ec2-${var.stage}-${var.servicename}"
  }, var.tags)

  lifecycle {
    ignore_changes = [user_data, associate_public_ip_address]
  }
}