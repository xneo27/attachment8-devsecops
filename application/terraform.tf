terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  open_access = "0.0.0.0/0"
  build_tool = "Terraform"
  https = {
    port = 443
    protocol = "tcp"
  }
  egress = {
    port = 0
    protocol = "-1"
  }
}
