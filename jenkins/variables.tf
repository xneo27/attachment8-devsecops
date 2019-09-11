variable "ec2-region" {
  description = "This is the AWS region"
  default     = "us-east-1"
}

variable "shared_credentials_file" {
  description = "This is the path to the shared credentials file. If this is not set and a profile is specified, ~/.aws/credentials will be used."
  default = "~/.aws/credentials"
}

variable "jenkins_master_instance_type" {
  description = "Jenkins Master instance type"
  default     = "t2.large"
}

variable "jenkins_slave_instance_type" {
  description = "Jenkins Slave instance type"
  default     = "t2.small"
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

variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}

variable "jenkins_key_name" {
  description = "SSH KeyPair"
}

variable "master_ami_name" {
  description = "The name to use for the master AMI"
}

variable "bastion_sg_id" {}

variable "slave_ami_name" {
  description = "The name to use for the slave AMI"
}

variable "author" {
  default = "Millennium Corporation"
}

variable "vpc_cidr_block" {}

variable "jenkins_username" {
}

variable "jenkins_password" {
}

variable "jenkins_pem" {}

variable "github_user" {}

variable "github_password" {}