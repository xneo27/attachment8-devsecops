terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.ec2_region
}

locals {
  open_access = "0.0.0.0/0"
  build_tool = "Terraform"
  bastion_name = "bastion"
  ssh = {
    port = 22
    protocol = "tcp"
  }
  egress = {
    port = 0
    protocol = "-1"
  }
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_host.id
}
