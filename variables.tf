variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}

variable "ec2-region" {
  description = "The AWS region"
}

variable "master_ami_name" {
  description = "The name to use for the master AMI"
}

variable "slave_ami_name" {
  description = "The name to use for the slave AMI"
}


// @TODO automate
variable "bastion_key_name" {
  default = "jenkins"
}
variable "jenkins_key_name" {
  default = "jenkins"
}

variable "jenkins_password" {}
variable "jenkins_username" {}