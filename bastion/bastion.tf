// Bastion host launch configuration
data "aws_ami" "bastion" {
  most_recent = true
  owners      = [var.ami_details.author]

  filter {
    name   = "name"
    values = [var.ami_details.name]
  }
}

# @todo autogenerate key?
resource "aws_launch_configuration" "bastion_conf" {
  name            = local.bastion_name
  image_id        = data.aws_ami.bastion.id
  instance_type   = var.bastion_instance_type
  key_name        = var.bastion_key_name
  security_groups = [aws_security_group.bastion_host.id]

  lifecycle {
    create_before_destroy = true
  }
}

// Bastion ASG
resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "${local.bastion_name}_asg_${var.vpc_name}"
  launch_configuration = aws_launch_configuration.bastion_conf.name
  vpc_zone_identifier  = var.public_subnet_ids
  load_balancers       = [aws_elb.bastion_hosts_elb.name]
  min_size             = 1
  max_size             = 1

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = local.bastion_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Author"
    value               = var.author
    propagate_at_launch = true
  }

  tag {
    key                 = "Tool"
    value               = local.build_tool
    propagate_at_launch = true
  }
}