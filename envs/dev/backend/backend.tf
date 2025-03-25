module "alb" {
  source = "../../../modules/network/alb"
  stage  = var.stage
  servicename = var.servicename
  vpc_id = var.vpc_id
  subnet_ids = var.public_subnets
  instance_ids = [module.ec2.ec2_id]
  internal = false
  idle_timeout = 60
  port = 8080
  target_type = "instance"
  hc_path = "/health"
  hc_healthy_threshold = 2
  hc_unhealthy_threshold = 3
  availability_zone = "all"
  aws_s3_lb_logs_name = "alb-logs-seoul"
  sg_allow_comm_list = ["0.0.0.0/0"]

  tags = {
    Service = var.servicename
    Stage = var.stage
  }
}

module "ec2" {
  source = "../../../modules/compute/ec2"
  stage  = var.stage
  servicename = var.servicename
  ami = var.ami
  instance_type = "t3.micro"
  subnet_id = var.private_subnets[0]
  associate_public_ip = false
  vpc_id = var.vpc_id
  ec2_port = 8080
  ssh_allow_comm_list = ["0.0.0.0/0"]
  allowed_sg_ids = [module.alb.sg_alb_id]
  ec2_iam_role_profile_name = var.ec2_iam_role_profile_name
  key_name = "aws-keypair-${var.stage}-${var.servicename}"
  is_port_forwarding = false
  kms_key_id = var.kms_key_id
  ebs_size = 30
  user_data = var.user_data

  tags = {
    Service = var.servicename
    Stage = var.stage
  }
}

module "rds" {
  source = "../../../modules/database/mysql"
  vpc_id = var.vpc_id
  stage  = var.stage
  db_name = "${var.servicename}db"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 100
  username = var.db_username
  password = var.db_password
  parameter_group = "default.mysql8.0"
  kms_key_arn = var.kms_key_id
  mysql_sg_id = module.ec2.sg_ec2_id
  db_subnet_group = var.db_subnet_group
  publicly_accessible = false
  multi_az = false

  tags = {
    Service = var.servicename
    Stage = var.stage
  }
}