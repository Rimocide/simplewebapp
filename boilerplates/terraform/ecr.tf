# ECR Repository
resource "aws_ecr_repository" "app" {
  name                 = "my-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "my-app-ecr" }
}

output "ecr_url" {
  value = aws_ecr_repository.app.repository_url
}
