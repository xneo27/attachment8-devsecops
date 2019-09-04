resource "aws_security_group" "bastion_elb" {
  name        = "${local.bastion_name}_elb_sg_${var.vpc_name}"
  description = "Allow SSH from ELB SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.ssh.port
    to_port     = local.ssh.port
    protocol    = local.ssh.protocol
    cidr_blocks = [local.open_access]
  }

  egress {
    from_port   = local.egress.port
    to_port     = local.egress.port
    protocol    = local.egress.protocol
    cidr_blocks = [local.open_access]
  }

  tags = {
    Name   = "${local.bastion_name}_elb_sg_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}

resource "aws_security_group" "bastion_host" {
  name        = "${local.bastion_name}_sg_${var.vpc_name}"
  description = "Allow SSH from ELB SG"
  vpc_id      = var.vpc_id

  egress {
    from_port   = local.egress.port
    to_port     = local.egress.port
    protocol    = local.egress.protocol
    cidr_blocks = [local.open_access]
  }

  ingress {
    from_port       = local.ssh.port
    to_port         = local.ssh.port
    protocol        = local.ssh.protocol
    security_groups = [aws_security_group.bastion_elb.id]
  }

  tags = {
    Name   = "${local.bastion_name}_sg_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}