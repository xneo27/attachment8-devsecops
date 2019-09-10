terraform {
  required_version = ">0.12"
}

provider "aws" {
  region = var.aws_region
}

data "template_file" "slave_provisioners" {
  template = file("${path.module}/templates/slave_provisioners.tpl")
  vars = {
    resource_path = "${path.module}/resources"
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

output "slave_ami_id" {
  value = data.aws_ami.jenkins-slave.id
}


//data "aws_ebs_snapshot" "jenkins-slave" {
//  snapshot_ids =  [data.aws_ami.jenkins-slave.root_snapshot_id]
//}
//
//data "template_file" "jenkins_slave_ami_tfstate" {
//  template = file("${path.module}/templates/terraform.instance.tpl")
//
//  vars = {
//    type = "aws_ami"
//    name = "jenkins-slave"
//    attributes = jsonencode(data.aws_ami.jenkins-slave)
//  }
//}
