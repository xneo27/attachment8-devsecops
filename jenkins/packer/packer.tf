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

data "template_file" "master_basic_security" {
  template = file("${path.module}/templates/basic-security.tpl")
  vars = {
    username = var.jenkins_username
    password = var.jenkins_password
  }
}

resource "local_file" "master_basic_security" {
  filename = "${path.module}/resources/master/basic-security.groovy"
  content = data.template_file.master_basic_security.rendered
}

data "template_file" "master_provisioners" {
  template = file("${path.module}/templates/master_provisioners.tpl")
  vars = {
    resource_path = "${path.module}/resources/master"
    cert_path = var.jenkins_pem
  }
}

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

resource "local_file" "master_ami" {
  filename = "${path.module}/resources/master_ami.json"
  content = data.template_file.master_ami.rendered
}

resource "null_resource" "master_ami" {
  provisioner "local-exec" {
    command = "packer build ${path.module}/resources/master_ami.json | tee ${path.module}/packer_output.txt"
  }

  depends_on = ["local_file.master_ami", "local_file.master_basic_security"]
}


data "template_file" "slave_provisioners" {
  template = file("${path.module}/templates/slave_provisioners.tpl")
  vars = {
    resource_path = "${path.module}/resources/slave"
  }
}

data "template_file" "slave_ami" {
  template = file("${path.module}/templates/ami.json.tpl")
  vars = {
    aws_region = var.aws_region
    ami_id = var.ami_id
    ami_subnet_id = var.ami_subnet_id
    ami_name = var.slave_ami_name
    ami_description = "Amazon Linux Image for Jenkins Slave"
    provisioners = data.template_file.slave_provisioners.rendered
    vpc_id = var.vpc_id
  }
}

resource "local_file" "slave_ami" {
  filename = "${path.module}/resources/slave_ami.json"
  content = data.template_file.slave_ami.rendered
}

resource "null_resource" "slave_ami" {
  provisioner "local-exec" {
    command = "packer build ${path.module}/resources/slave_ami.json"
  }

  depends_on = ["local_file.slave_ami"]
}


data "aws_ami" "jenkins-slave" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.slave_ami_name]
  }

  depends_on = ["null_resource.slave_ami"]
}

data "aws_ebs_snapshot" "jenkins-slave" {
  snapshot_ids =  [data.aws_ami.jenkins-slave.root_snapshot_id]
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

data "aws_ebs_snapshot" "jenkins-master" {
  snapshot_ids =  [data.aws_ami.jenkins-master.root_snapshot_id]
}

data "template_file" "jenkins_master_ami_tfstate" {
  template = file("${path.module}/templates/terraform.instance.tpl")

  vars = {
    type = "aws_ami"
    name = "jenkins-master"
    attributes = jsonencode(data.aws_ami.jenkins-master)
  }
}

data "template_file" "jenkins_slave_ami_tfstate" {
  template = file("${path.module}/templates/terraform.instance.tpl")

  vars = {
    type = "aws_ami"
    name = "jenkins-slave"
    attributes = jsonencode(data.aws_ami.jenkins-slave)
  }
}

data "template_file" "jenkins_master_snapshot_tfstate" {
  template = file("${path.module}/templates/terraform.instance.tpl")

  vars = {
    type = "aws_ebs_snapshot"
    name = "jenkins-master"
    attributes = jsonencode(data.aws_ebs_snapshot.jenkins-master)
  }
}

data "template_file" "jenkins_slave_snapshot_tfstate" {
  template = file("${path.module}/templates/terraform.instance.tpl")

  vars = {
    type = "aws_ebs_snapshot"
    name = "jenkins-slave"
    attributes = jsonencode(data.aws_ebs_snapshot.jenkins-slave)
  }
}

data "template_file" "terraform_state" {
  template = file("${path.module}/templates/terraform.state.tpl")

  vars = {
    resources = join(", ", [data.template_file.jenkins_master_ami_tfstate.rendered, data.template_file.jenkins_slave_ami_tfstate.rendered, data.template_file.jenkins_master_snapshot_tfstate.rendered, data.template_file.jenkins_slave_snapshot_tfstate.rendered])
  }
}

resource "local_file" "jenkins-master-snap" {
  filename = "${path.module}/tf/terraform.tfstate"
  content = data.template_file.terraform_state.rendered
}

output "master_ami_id" {
  value = data.aws_ami.jenkins-master.id
}

output "slave_ami_id" {
  value = data.aws_ami.jenkins-slave.id
}

