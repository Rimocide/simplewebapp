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
    from_port = 5432
    to_port = 5432 
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

