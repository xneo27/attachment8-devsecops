variable "vpc_name" {
  description = "The name of the VPC"
  default = "Attachment8"
}

variable "cidr_block" {
  description = "The available cidr blocks for the VPC"
  default = "10.0.0.0/21"
}


variable "max_availability_zones" {
  description = "The availability zones to utilize for subnetting"
  default = 4
}

variable "author" {
  description = "The infrastructure author"
  default = "Millennium Corporation"
}

variable "ec2_region" {
  description = "The AWS region to build out"
  default = "us-east-2"
}