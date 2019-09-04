terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.ec2_region
}

locals {
  open_access = "0.0.0.0/0"
  build_tool = "Terraform"
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_name" {
  value = aws_vpc.default.tags.Name
}