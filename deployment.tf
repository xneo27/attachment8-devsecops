terraform {
  required_version = ">= 0.12"
}

module "aws" {
  source = "./aws"
  ec2_region = "us-east-1"
}

module "bastion" {
  source = "./bastion"

  private_subnet_ids = module.aws.private_subnet_ids
  public_subnet_ids = module.aws.public_subnet_ids

  vpc_name = module.aws.vpc_name
  vpc_id = module.aws.vpc_id
  bastion_key_name = "jenkins"

  ec2_region = "us-east-1"
}