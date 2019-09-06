variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "public_subnet_ids" {
  description = "An array of the public subnets"
}

variable "private_subnet_ids" {
  description = "An array of the private subnets"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "jenkins_master_instance_type" {
  description = "Jenkins Master instance type"
}

variable "jenkins_slave_instance_type" {
  description = "Jenkins Slave instance type"
}

variable "jenkins_key_name" {}

variable "author" {
  default = "Millennium Corporation"
}

variable "jenkins_username" {
}

variable "jenkins_password" {
}

variable "jenkins_credentials_id" {
  // @TODO what goes here?
  default = "jenkins"
}

variable "min_jenkins_slaves" {
  default = 1
}

variable "max_jenkins_slaves" {
  default = 5
}

variable "bastion_sg_id" {}

variable "vpc_cidr_block" {}

variable "slave_ami_id" {}

variable "master_ami_id" {}