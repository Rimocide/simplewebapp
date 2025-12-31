#!/bin/bash
set -e

# Log output
exec > /var/log/userdata.log 2>&1

# Update and install Docker (Amazon Linux 2)
yum update -y
yum install -y docker git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Clone repo and run
mkdir -p /var/www
cd /var/www
git clone https://github.com/USERNAME/REPO.git app
cd app

# Create env file
cat > .env << EOF
DB_HOST=10.0.2.100
DB_USER=admin
DB_PASSWORD=password
DB_NAME=appdb
EOF

# Run containers
docker-compose up -d --build
