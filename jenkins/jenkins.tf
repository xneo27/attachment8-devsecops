terraform {
  required_version = ">0.12"
}

module "master" {
  source = "./master"
  ami_subnet_id = var.public_subnet_ids[0]
  bastion_sg_id = var.bastion_sg_id
  domain_name = var.domain_name
  jenkins_key_name = var.jenkins_key_name
  jenkins_master_instance_type = var.jenkins_master_instance_type
  jenkins_password = var.jenkins_password
  jenkins_username = var.jenkins_username
  private_subnet_ids = var.private_subnet_ids
  public_subnet_ids = var.public_subnet_ids
  vpc_cidr_block = var.vpc_cidr_block
  vpc_id = var.vpc_id
  master_ami_name = var.master_ami_name
  jenkins_pem = var.jenkins_pem
  github_password = var.github_password
  github_user = var.github_user
}



module "slave" {
  source = "./slave"
  ami_subnet_id = var.public_subnet_ids[0]
  bastion_sg_id = var.bastion_sg_id
  domain_name = var.domain_name
  jenkins_key_name = var.jenkins_key_name
  jenkins_master_sg = module.master.jenkins_master_sg
  jenkins_password = var.jenkins_password
  jenkins_slave_instance_type = var.jenkins_slave_instance_type
  jenkins_username = var.jenkins_username
  master_ip = module.master.jenkins_master_ip
  private_subnet_ids = var.private_subnet_ids
  slave_ami_id = module.slave.slave_ami_id
  slave_ami_name = var.slave_ami_name
  vpc_id = var.vpc_id
  jenkins_elb_id = module.master.jenkins_elb_id
}