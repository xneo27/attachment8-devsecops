resource "aws_security_group" "jenkins_master_sg" {
  name        = "jenkins_master_sg"
  description = "Allow traffic on port 8080 and enable SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = local.ssh.port
    to_port         = local.ssh.port
    protocol        = local.ssh.protocol
//    cidr_blocks = [aws_security_group.elb_jenkins_sg]
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    from_port       = local.jenkins_http.port
    to_port         = local.jenkins_http.port
    protocol        = local.jenkins_http.protocol
    cidr_blocks     = [var.vpc_cidr_block]
    security_groups = [aws_security_group.elb_jenkins_sg.id]
  }

  egress {
    from_port   = local.egress.port
    to_port     = local.egress.port
    protocol    = local.egress.protocol
    cidr_blocks = [local.open_access]
  }

  tags = {
    Name   = "jenkins_master_sg"
    Author = var.author
    Tool   = local.build_tool
  }
}

resource "aws_security_group" "elb_jenkins_sg" {
  name        = "elb_jenkins_sg"
  description = "Allow https traffic"
  vpc_id      = var.vpc_id

//  ingress {
//    from_port   = local.https.port
//    to_port     = local.https.port
//    protocol    = local.https.protocol
//    cidr_blocks = [local.open_access]
//  }

  // @TODO replace this ingress with commented ingress above once cert limit is restored
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.open_access]
  }

  egress {
    from_port   = local.egress.port
    to_port     = local.egress.port
    protocol    = local.egress.protocol
    cidr_blocks = [local.open_access]
  }

  tags = {
    Name   = "elb_jenkins_sg"
    Author = var.author
    Tool   = local.build_tool
  }
}