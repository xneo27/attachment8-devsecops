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

variable "master_ami_name" {
  description = "The name to use to create the master AMI"
}
