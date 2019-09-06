variable "ami_id" {
  description = "The ID of the base AMI (see https://aws.amazon.com/amazon-linux-ami/)"
  default = "ami-0ff8a91507f77f867"
}

variable "aws_region" {
  description = "The AWS region (Note: changing this may require chainging the ami_id)"
  default = "us-east-1"
}

variable "jenkins_pem" {
  description = "The .pem file to use for the jenkins AMI"
  default = "/Users/sean.warner/keys/jenkins.pem"
}

variable "slave_ami_name" {
  description = "The name to use to create the slave AMI"
}

variable "master_ami_name" {
  description = "The name to use to create the master AMI"
}

variable "ami_subnet_id" {}

variable "vpc_id" {}

variable "jenkins_username" {
}

variable "jenkins_password" {
}