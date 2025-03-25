# VPC 생성
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.stage}"
  }
}

# 퍼블릭 서브넷 생성 (AZ 개수만큼 자동 생성)
resource "aws_subnet" "public_subnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}-${var.stage}"
  }
}

# 프라이빗 서브넷 생성 (AZ 개수만큼 자동 생성)
resource "aws_subnet" "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, length(var.azs) + count.index)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}-${var.stage}"
  }
}

# DB 서브넷 생성 (AZ 개수만큼 자동 생성)
resource "aws_subnet" "db_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 2 * length(var.azs) + count.index)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "db-subnet-${count.index + 1}-${var.stage}"
  }
}

# DB 서브넷 그룹 생성
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group-${var.stage}"
  subnet_ids = aws_subnet.db_subnets[*].id

  tags = {
    Name = "db-subnet-group-${var.stage}"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw-${var.stage}"
  }
}

# Elastic IP (NAT Gateway용) - AZ 개수만큼 생성
resource "aws_eip" "nat_eip" {
  count = length(var.azs)
}

# NAT Gateway (AZ 개수만큼 생성)
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  depends_on = [aws_internet_gateway.igw]
}

# 퍼블릭 라우트 테이블 생성
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# 퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# 프라이빗 라우트 테이블 (AZ 개수만큼 생성)
resource "aws_route_table" "private_rt" {
  count = length(var.azs)
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "private-route-table-${count.index + 1}-${var.stage}"
  }
}

# 프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "private_assoc" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}