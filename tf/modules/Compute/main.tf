terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }

resource "aws_instance" "public" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.public_sg_id]

  tags = {
    Name = "Public EC2"
  }
}

resource "aws_instance" "private" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  subnet_id = var.private_subnet
  vpc_security_group_ids = [var.private_sg_id]

  tags = {
    Name = "Private EC2"
  }
}


