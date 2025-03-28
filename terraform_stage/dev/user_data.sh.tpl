#!/bin/bash

# ---------------------------------------
# 1. CodeDeploy Agent 설치
# ---------------------------------------
sudo apt update -y
sudo apt install -y ruby wget

cd /home/ubuntu
wget https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent

# ---------------------------------------
# 2. Docker 설치
# ---------------------------------------
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker 공식 GPG 키 추가
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker repository 등록
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker 및 Docker Compose 설치
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 시작 및 권한 부여
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# ---------------------------------------
# 3. AWS CLI 설치
# ---------------------------------------
sudo apt-get install -y awscli

# ---------------------------------------
# 4. ECR 로그인
# ---------------------------------------
aws ecr get-login-password --region ${region} | \
docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com
