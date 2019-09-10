resource "aws_instance" "jenkins_master" {
  ami                    = var.master_ami_id
  instance_type          = var.jenkins_master_instance_type
  key_name               = var.jenkins_key_name
  vpc_security_group_ids = [aws_security_group.jenkins_master_sg.id]
  subnet_id              = element(var.private_subnet_ids, 0)

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  tags = {
    Name   = "jenkins_master"
    Author = var.author
    Tool   = local.build_tool
  }
}