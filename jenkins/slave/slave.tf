terraform {
  required_version = ">=0.12"
  //  backend "s3" {
  //    encrypt = "true"
  //    bucket  = "terraform-state-nexus-user-conference"
  //    region  = "us-east-2"
  //    key     = "jenkins/terraform.tfstate.json"
  //  }
}

module "packer" {
  source = "./packer"
  aws_region = var.aws_region
  ami_subnet_id = var.ami_subnet_id
  master_ami_name = var.master_ami_name
  slave_ami_name = var.slave_ami_name
  vpc_id = var.vpc_id
}

module "deploy" {
  source = "./deploy"
  aws_region = var.aws_region
  bastion_sg_id = var.bastion_sg_id
  domain_name = var.domain_name
  jenkins_key_name = var.jenkins_key_name
  jenkins_master_sg = var.jenkins_master_sg
  jenkins_password = var.jenkins_password
  jenkins_slave_instance_type = var.jenkins_slave_instance_type
  jenkins_username = var.jenkins_username
  master_ip = var.master_ip
  private_subnet_ids = var.private_subnet_ids
  slave_ami_id = var.slave_ami_id
  vpc_id = var.vpc_id
  jenkins_elb_id = var.jenkins_elb_id
}

output "slave_ami_id" {
  value = module.packer.slave_ami_id
}