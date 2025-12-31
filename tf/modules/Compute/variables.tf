variable private_sg_id {}
variable public_sg_id {}
variable vpc_id {}
variable public_subnet {}
variable private_subnet {}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ecr_repository" {
  type    = string
  default = "simplewebapp-db"
}
