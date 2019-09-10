variable "author" {
  default = "Millennium Corporation"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}

variable "master_ip" {}

variable "jenkins_username" {
}

variable "jenkins_password" {
}

variable "jenkins_credentials_id" {
  default = "jenkins-slaves"
}

variable "slave_ami_id" {}

variable "jenkins_slave_instance_type" {
  description = "Jenkins Slave instance type"
}

variable "jenkins_key_name" {}

variable "private_subnet_ids" {
  description = "An array of the private subnets"
}

variable "min_jenkins_slaves" {
  default = 1
}

variable "max_jenkins_slaves" {
  default = 5
}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "bastion_sg_id" {}

variable "jenkins_master_sg" {}

variable "jenkins_elb_id" {}