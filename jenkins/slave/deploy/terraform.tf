terraform {
  required_version = ">=0.12"
  //  backend "s3" {
  //    encrypt = "true"
  //    bucket  = "terraform-state-nexus-user-conference"
  //    region  = "us-east-2"
  //    key     = "jenkins/terraform.tfstate.json"
  //  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  open_access = "0.0.0.0/0"
  build_tool = "Terraform"
  jenkins_endpoint = "jenkins.${var.domain_name}"
  ssh = {
    port = 22
    protocol = "tcp"
  }
  https = {
    port = 443
    protocol = "tcp"
  }
  jenkins_http = {
    port = 8080
    protocol = "tcp"
  }
  egress = {
    port = 0
    protocol = "-1"
  }
}