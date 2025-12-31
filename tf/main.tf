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

  vpc_id = module.Network.vpc_id 
  vpc_cidr_block = module.Network.vpc_cidr
}

module "Compute" {
  source = "./modules/Compute"

  private_sg_id = module.Security.private_sg_id
  public_sg_id = module.Security.public_sg_id
  vpc_id = module.Network.vpc_id
  public_subnet = module.Network.public_subnet_id
  private_subnet = module.Network.private_subnet_id
}
