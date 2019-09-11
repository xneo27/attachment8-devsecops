// @TODO Reformat for readability
// @TODO correct depends on reliance in generated state file for packer destroy
// @TODO add hooks for packer destroy
// @TODO consider simpler packer destroy. AWS CLI?

terraform {
  required_version = ">0.12"
}

provider "aws" {
  region = var.aws_region
}


# Configure script for default UN/PW for Jenkins Master
data "template_file" "master_basic_security" {
  template = file("${path.module}/templates/basic-security.tpl")
  vars = {
    username = var.jenkins_username
    password = var.jenkins_password
  }
}

# Configure master configuration file
data "template_file" "master_provisioners" {
  template = file("${path.module}/templates/master_provisioners.tpl")
  vars = {
    resource_path = "${path.module}/resources/"
    cert_path = var.jenkins_pem
  }

  depends_on = ["local_file.jobs"]
}

# Configure master AMI configuration file
data "template_file" "master_ami" {
  template = file("${path.module}/templates/ami.json.tpl")
  vars = {
    aws_region = var.aws_region
    ami_id = var.ami_id
    ami_subnet_id = var.ami_subnet_id
    ami_name = var.master_ami_name
    ami_description = "Amazon Linux Image with Jenkins Server"
    provisioners = data.template_file.master_provisioners.rendered
    vpc_id = var.vpc_id
  }
}

data "template_file" "jobs" {
  template = file("${path.module}/templates/jobs.tpl")
  vars = {
    secret = var.github_secret
    description = var.github_description
    owner = var.github_owner
    repository = var.github_repo
  }
}

resource "local_file" "jobs" {
  filename = "${path.module}/resources/jobs.yml"
  content = data.template_file.jobs.rendered
}

# TODO fix references above; add file (to jenkins.yaml)


# Set up default UN/PW for Jenkins Master
resource "local_file" "master_basic_security" {
  filename = "${path.module}/resources/basic-security.groovy"
  content = data.template_file.master_basic_security.rendered
}


# Build master AMI configuration file
resource "local_file" "master_ami" {
  filename = "${path.module}/resources/master_ami.json"
  content = data.template_file.master_ami.rendered
}

# Build master AMI
resource "null_resource" "master_ami" {
  provisioner "local-exec" {
    command = "packer build ${path.module}/resources/master_ami.json | tee ${path.module}/packer_output.txt"
  }

  depends_on = ["local_file.master_ami", "local_file.master_basic_security"]
}

data "aws_ami" "jenkins-master" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.master_ami_name]
  }

  depends_on = ["null_resource.master_ami"]
}

output "master_ami_id" {
  value = data.aws_ami.jenkins-master.id
}

//data "aws_ebs_snapshot" "jenkins-master" {
//  snapshot_ids =  [data.aws_ami.jenkins-master.root_snapshot_id]
//}
//
//data "template_file" "jenkins_master_ami_tfstate" {
//  template = file("${path.module}/templates/terraform.instance.tpl")
//
//  vars = {
//    type = "aws_ami"
//    name = "jenkins-master"
//    attributes = jsonencode(data.aws_ami.jenkins-master)
//  }
//}
//
//data "template_file" "jenkins_master_snapshot_tfstate" {
//  template = file("${path.module}/templates/terraform.instance.tpl")
//
//  vars = {
//    type = "aws_ebs_snapshot"
//    name = "jenkins-master"
//    attributes = jsonencode(data.aws_ebs_snapshot.jenkins-master)
//  }
//}
//
//data "aws_ami" "jenkins-master" {
//  most_recent = true
//  owners      = ["self"]
//
//  filter {
//    name   = "name"
//    values = [var.master_ami_name]
//  }
//
//  depends_on = ["null_resource.master_ami"]
//}
//
//data "aws_ebs_snapshot" "jenkins-master" {
//  snapshot_ids =  [data.aws_ami.jenkins-master.root_snapshot_id]
//}
//
//data "template_file" "jenkins_master_ami_tfstate" {
//  template = file("${path.module}/templates/terraform.instance.tpl")
//
//  vars = {
//    type = "aws_ami"
//    name = "jenkins-master"
//    attributes = jsonencode(data.aws_ami.jenkins-master)
//  }
//}
