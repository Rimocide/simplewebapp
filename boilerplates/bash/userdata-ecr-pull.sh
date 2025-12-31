#!/bin/bash
set -e

# Log output
exec > /var/log/userdata.log 2>&1

# Variables (passed from Terraform templatefile)
AWS_REGION="${aws_region}"
ECR_REPO="${ecr_repository}"

# Update and install Docker + AWS CLI
yum update -y
yum install -y docker aws-cli
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Wait for VPC endpoints
sleep 30

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

# Pull and run container
docker pull $ECR_REPO:latest
docker run -d \
  --name app \
  --restart unless-stopped \
  -p 80:80 \
  $ECR_REPO:latest
