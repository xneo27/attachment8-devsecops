terraform {
  required_version = ">= 0.12"
}

locals {
  cidr_block = "10.0.0.0/21"
}

module "aws" {
  source = "./aws"
  ec2_region = var.ec2-region
  cidr_block = local.cidr_block
}

module "bastion" {
  source = "./bastion"

  private_subnet_ids = module.aws.private_subnet_ids
  public_subnet_ids = module.aws.public_subnet_ids

  vpc_name = module.aws.vpc_name
  vpc_id = module.aws.vpc_id
  bastion_key_name = var.bastion_key_name

  ec2_region = var.ec2-region

  domain_name = var.domain_name
}

module "jenkins" {
  source = "./jenkins"

  public_subnet_ids = module.aws.public_subnet_ids
  private_subnet_ids = module.aws.private_subnet_ids
  domain_name = var.domain_name
  ec2-region = var.ec2-region

  master_ami_name = var.master_ami_name
  slave_ami_name = var.slave_ami_name
  jenkins_key_name = var.jenkins_key_name
  vpc_id = module.aws.vpc_id
  bastion_sg_id = module.bastion.bastion_sg_id
  vpc_cidr_block = local.cidr_block
  jenkins_password = var.jenkins_password
  jenkins_username = var.jenkins_username
  github_password = var.github_password
  github_user = var.github_user
  jenkins_pem = var.jenkins_pem
}

module "application" {
  source = "./application"
  api_git_url = var.api_git_url
  api_git_version = var.api_git_version
  availability_zones = module.aws.availability_zones
  bastion_sg_id = module.bastion.bastion_sg_id
  bucket_name = var.s3_bucket_name
  private_subnet_ids = module.aws.private_subnet_ids
  vpc_id = module.aws.vpc_id
  ec2_region = var.ec2-region
}

# @TODO https://github.com/terraform-providers/terraform-provider-aws/issues/4560