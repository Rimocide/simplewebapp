terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "publicEc2Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id 
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "privateEc2Subnet"
  }
}

resource "aws_internet_gateway" "igw_gateway" {
  vpc_id = aws_vpc.main.id 
}

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.main.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_gateway.id 
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.main.id 
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id 
  route_table_id = aws_route_table.publicroute.id 
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id 
  route_table_id = aws_route_table.privateroute.id
}

