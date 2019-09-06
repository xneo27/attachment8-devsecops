variable "private_subnet_ids" {
  description = "The IDs of the AWS private subnets"
}

variable "public_subnet_ids" {
  description = "The IDs of the AWS public subnets"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "author" {
  default = "Millennium Corporation"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "ami_details" {
  description = "AMI desired for bastion image (name, author are mandatory keys)"
  type = "map"
  default = {
    "name" = "amzn-ami-hvm-2018.03.0.20180412-x86_64-ebs"
    "author" = "amazon"
  }
}

variable "bastion_key_name" {}

variable "ec2_region" {
  default = "us-east-2"
}

variable "domain_name" {
  description = "The domain name to utilize for endpoints"
}
