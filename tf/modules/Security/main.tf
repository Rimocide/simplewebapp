terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }


resource "aws_security_group" "public_sg" {
  name = "public_sg"
  description = "Allow SSH/HTTP/HTTPs traffic"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 443
    to_port = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 80
    to_port = 80
  } 
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 22
    to_port = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0 
    to_port = 0 
    protocol = "-1"
  }

}

resource "aws_security_group" "private_sg" {
  name = "private_sg"
  description = "Allowing communication between private-public"
  vpc_id = var.vpc_id 

  ingress {
    security_groups = [aws_security_group.public_sg.id] 
    protocol = "tcp"
    from_port = 3306
    to_port = 3306 
  }

  ingress {
    cidr_blocks = [var.ssh_ip]
    protocol = "tcp"
    from_port = 22
    to_port = 22
  }

  egress {
    protocol = "-1"
    cidr_blocks = [var.vpc_cidr_block]
    from_port = 0 
    to_port = 0 
  }
}

# Security group for VPC endpoints (ECR access)
resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VPC Endpoints for ECR (so private subnet can pull images without internet)
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

# S3 endpoint (ECR uses S3 for image layers)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_route_table_id]

  tags = {
    Name = "s3-endpoint"
  }
}

# ECR Repository for database image
resource "aws_ecr_repository" "database" {
  name                 = "simplewebapp-db"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    Name = "simplewebapp-db"
  }
}

