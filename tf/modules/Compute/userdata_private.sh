#!/bin/bash
set -e

# Update system and install Docker
apt update -y
apt install -y docker aws-cli
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Wait for ECR endpoints to be ready
sleep 30

# Login to ECR and pull database image
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_repository}

# Pull database image from ECR
docker pull ${ecr_repository}:latest

# Run database container
docker run -d \
  --name simple-database \
  --restart unless-stopped \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=simpleapp \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=password \
  -p 3306:3306 \
  ${ecr_repository}:latest
