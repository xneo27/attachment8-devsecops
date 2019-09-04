// Bastion ELB
resource "aws_elb" "bastion_hosts_elb" {
  subnets                   = var.public_subnet_ids
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.bastion_elb.id]

  listener {
    instance_port     = local.ssh.port
    instance_protocol = local.ssh.protocol
    lb_port           = local.ssh.port
    lb_protocol       = local.ssh.protocol
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${local.ssh.protocol}:${local.ssh.port}"
    interval            = 30
  }

  tags = {
    Name   = "${local.bastion_name}_elb_${var.vpc_name}"
    Author = var.author
    Tool   = local.build_tool
  }
}