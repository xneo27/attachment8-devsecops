variable "ec2_region" {
  default = "us-east-2"
}

variable "author" {
  default = "Millennium Corporation"
}

variable "vpc_id" {}

variable "api_git_version" {
  description = "The Git version for the api gateway (master, develop, etc)"
}

variable "api_git_url" {
  description = "The git uri for the api gateway"
}

variable "ingester_get_url" {
  description = "The git url for the actor ingester"
}

variable "bucket_name" {}

variable "availability_zones" {}

variable "bastion_sg_id" {}

variable "private_subnet_ids" {
  description = "The IDs of the AWS private subnets"
}

variable "public_subnet_ids" {
  description = "The IDs of the AWS public subnets"
}