variable "author" {
  default = "Millennium Corporation"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}

variable "public_subnet_ids" {
  description = "An array of the public subnets"
}

variable "private_subnet_ids" {
  description = "An array of the private subnets"
}

variable "master_ami_id" {}

variable "jenkins_master_instance_type" {
  description = "Jenkins Master instance type"
}

variable "jenkins_key_name" {}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "bastion_sg_id" {}

variable "vpc_cidr_block" {}