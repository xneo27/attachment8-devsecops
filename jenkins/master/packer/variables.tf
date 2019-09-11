variable "aws_region" {
  description = "This is the AWS region"
  default     = "us-east-1"
}

variable "jenkins_username" {}

variable "jenkins_password" {
}

variable "jenkins_pem" {
  description = "The .pem file to use for the jenkins AMI"
}

variable "ami_id" {
  description = "The ID of the base AMI (see https://aws.amazon.com/amazon-linux-ami/)"
  default = "ami-0ff8a91507f77f867"
}

variable "ami_subnet_id" {}

variable "master_ami_name" {
  description = "The name to use to create the master AMI"
}

variable "vpc_id" {}

variable "github_secret" {
  default = "github"
}
variable "github_description" {
  default = "The github ingester"
}
variable "github_owner" {
  default = "millgroupinc"
}
variable "github_repo" {
  default = "attachment8-ingesters"
}

variable "github_user" {}

variable "github_password" {}