terraform {
  required_version = ">0.12"
}

module "packer" {
  source = "./packer"
  master_ami_name = var.master_ami_name
  slave_ami_name = var.slave_ami_name
  aws_region = var.ec2-region
  vpc_id = var.vpc_id
  ami_subnet_id = var.public_subnet_ids[0]
  jenkins_password = var.jenkins_password
  jenkins_username = var.jenkins_username
}

module "deploy" {
  source = "./deploy"
  domain_name = var.domain_name
  public_subnet_ids = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids
  aws_region = var.ec2-region
  jenkins_master_instance_type = var.jenkins_master_instance_type
  jenkins_slave_instance_type = var.jenkins_slave_instance_type
  jenkins_key_name = var.jenkins_key_name
  author = var.author
  vpc_id = var.vpc_id
  bastion_sg_id = var.bastion_sg_id
  vpc_cidr_block = var.vpc_cidr_block
  master_ami_id = module.packer.master_ami_id
  slave_ami_id = module.packer.slave_ami_id
  jenkins_password = var.jenkins_password
  jenkins_username = var.jenkins_username
}
