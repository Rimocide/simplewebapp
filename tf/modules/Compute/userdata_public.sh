#!/bin/bash
set -e

# Log output for debugging
exec > /var/log/userdata.log 2>&1

# Update system and install Docker
apt update -y
apt install -y docker git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Clone repository
mkdir -p /var/www
cd /var/www
git clone https://github.com/Rimocide/simplewebapp.git
cd simplewebapp

# Create .env file with database host (private EC2 IP)
cat > .env << EOF
DB_HOST=${db_host}
DB_USER=admin
DB_PASSWORD=password
DB_NAME=simpleapp
EOF

# Wait for database to be ready (give private instance time to start)
sleep 60

# Build and run frontend + backend containers
docker-compose -f docker-compose.public.yml up -d --build
