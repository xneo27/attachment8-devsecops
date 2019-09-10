variable "author" {
  default = "Millennium Corporation"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ami_subnet_id" {}

variable "jenkins_username" {
}

variable "jenkins_password" {
}

variable "vpc_id" {}

variable "bastion_sg_id" {}

variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}

variable "jenkins_key_name" {}

variable "public_subnet_ids" {
  description = "An array of the public subnets"
}

variable "private_subnet_ids" {
  description = "An array of the private subnets"
}

variable "jenkins_master_instance_type" {
  description = "Jenkins Master instance type"
}

variable "vpc_cidr_block" {}

variable "master_ami_name" {
  description = "The name to use to create the master AMI"
}