terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }

# Generate key pair for SSH access
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "simplewebapp-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.root}/simplewebapp-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "public" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key_pair.key_name

  user_data = templatefile("${path.module}/userdata_public.sh", {
    db_host = aws_instance.private.private_ip
  })

  tags = {
    Name = "Public EC2"
  }

  depends_on = [aws_instance.private]
}

resource "aws_instance" "private" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet
  vpc_security_group_ids = [var.private_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.ecr_profile.name

  user_data = templatefile("${path.module}/userdata_private.sh", {
    aws_region     = var.aws_region
    ecr_repository = var.ecr_repository
  })

  tags = {
    Name = "Private EC2"
  }
}

# IAM role for private EC2 to pull from ECR
resource "aws_iam_role" "ecr_role" {
  name = "ecr-pull-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ecr_profile" {
  name = "ecr-pull-profile"
  role = aws_iam_role.ecr_role.name
}


