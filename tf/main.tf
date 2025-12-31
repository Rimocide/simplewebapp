terraform {
  required_providers {
   aws = {
    source = "hashicorp/aws"
    version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "Network" {
  source = "./modules/Network"
}

module "Security" {
  source = "./modules/Security"

  vpc_id            = module.Network.vpc_id
  vpc_cidr_block    = module.Network.vpc_cidr
  private_subnet_id = module.Network.private_subnet_id
  private_route_table_id = module.Network.private_route_table_id
}

module "Compute" {
  source = "./modules/Compute"

  private_sg_id  = module.Security.private_sg_id
  public_sg_id   = module.Security.public_sg_id
  vpc_id         = module.Network.vpc_id
  public_subnet  = module.Network.public_subnet_id
  private_subnet = module.Network.private_subnet_id
  ecr_repository = module.Security.ecr_repository_url

  depends_on = [module.Security]
}

# Outputs
output "public_ec2_ip" {
  value = module.Compute.public_ec2_ip
}

output "private_ec2_ip" {
  value = module.Compute.private_ec2_ip
}

output "ecr_repository_url" {
  value = module.Security.ecr_repository_url
}

output "ssh_private_key" {
  value     = module.Compute.ssh_private_key
  sensitive = true
}
}

output "ssh_private_key" {
  value     = module.Compute.ssh_private_key
  sensitive = true
}
