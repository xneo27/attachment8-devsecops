resource "aws_security_group" "elastic_search" {
  name        = "Elastic Search SG"
  description = "Elastic Search SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.https.port
    to_port     = local.https.port
    protocol    = local.https.protocol
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    from_port = local.https.port
    protocol = local.https.protocol
    to_port = local.https.port
    self = true
  }

  egress {
    from_port   = local.egress.port
    to_port     = local.egress.port
    protocol    = local.egress.protocol
    cidr_blocks = [local.open_access]
  }

  tags = {
    Name   = "Elastic Search SG"
    Author = var.author
    Tool   = local.build_tool
  }
}