resource "aws_security_group" "jenkins_slaves_sg" {
  name        = "jenkins_slaves_sg"
  description = "Allow traffic on port 22 from Jenkins Master SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = local.ssh.port
    to_port         = local.ssh.port
    protocol        = local.ssh.protocol
    security_groups = [var.jenkins_master_sg, var.bastion_sg_id]
  }

  egress {
    from_port   = local.egress.port
    to_port     = local.egress.port
    protocol    = local.egress.protocol
    cidr_blocks = [local.open_access]
  }

  tags = {
    Name   = "jenkins_slaves_sg"
    Author = var.author
    Tool   = local.build_tool
  }
}