variable "aws_region" {
  description = "This is the AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The ID of the base AMI (see https://aws.amazon.com/amazon-linux-ami/)"
  default = "ami-0ff8a91507f77f867"
}

variable "ami_subnet_id" {}

variable "slave_ami_name" {
  description = "The name to use to create the slave AMI"
}

variable "vpc_id" {}

variable "author" {
  default = "Millennium Corporation"
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

variable "bastion_sg_id" {}

variable "jenkins_master_sg" {}

variable "jenkins_elb_id" {}