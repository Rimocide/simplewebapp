variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "ssh_ip" {
  type = string
  default = "182.176.222.244/32"
}

variable "private_subnet_id" {
  type = string
}

variable "private_route_table_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

