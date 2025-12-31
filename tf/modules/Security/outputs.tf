output "public_sg_id" {
  value = aws_security_group.public_sg.id  
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id  
}

output "vpc_endpoints_sg_id" {
  value = aws_security_group.vpc_endpoints_sg.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.database.repository_url
}
