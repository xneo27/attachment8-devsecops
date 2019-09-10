// Jenkins ELB
resource "aws_elb" "jenkins_elb" {
  subnets                   = var.public_subnet_ids
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_jenkins_sg.id]
  instances                 = [aws_instance.jenkins_master.id]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    // @TODO FIX THIS! Should be 443/https
    lb_port            = 80
    lb_protocol        = "http"
//    ssl_certificate_id = aws_acm_certificate_validation.jenkins.certificate_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 5
  }

  tags = {
    Name   = "jenkins_elb"
    Author = var.author
    Tool   = local.build_tool
  }
}