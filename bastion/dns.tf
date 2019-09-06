data "aws_route53_zone" "hosting_zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "bastion" {
  name = "bastion.${var.domain_name}"
  type = "A"
  zone_id = data.aws_route53_zone.hosting_zone.zone_id

  alias {
    name                   = "${aws_elb.bastion_hosts_elb.dns_name}"
    zone_id                = "${aws_elb.bastion_hosts_elb.zone_id}"
    evaluate_target_health = true
  }
}