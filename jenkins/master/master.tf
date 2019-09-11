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
  jenkins_password = var.jenkins_password
  jenkins_username = var.jenkins_username
  master_ami_name = var.master_ami_name
  vpc_id = var.vpc_id
  jenkins_pem = var.jenkins_pem
  github_password = var.github_password
  github_user = var.github_user
}

module "deploy" {
  source = "./deploy"
  author = var.author
  aws_region = var.aws_region
  bastion_sg_id = var.bastion_sg_id
  domain_name = var.domain_name
  jenkins_key_name = var.jenkins_key_name
  jenkins_master_instance_type = var.jenkins_master_instance_type
  master_ami_id = module.packer.master_ami_id
  private_subnet_ids = var.private_subnet_ids
  public_subnet_ids = var.public_subnet_ids
  vpc_cidr_block = var.vpc_cidr_block
  vpc_id = var.vpc_id
}

output "jenkins_master_sg" {
  value = module.deploy.jenkins_master_sg
}

output "jenkins_master_ip" {
  value = module.deploy.master_ip
}

output "jenkins_elb_id" {
  value = module.deploy.aws_elb
}
