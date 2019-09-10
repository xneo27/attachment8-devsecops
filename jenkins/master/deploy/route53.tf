data "aws_route53_zone" "hosting_zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "jenkins_master" {
  zone_id = data.aws_route53_zone.hosting_zone.zone_id
  name    = local.jenkins_endpoint
  type    = "A"

  alias {
    name                   = aws_elb.jenkins_elb.dns_name
    zone_id                = aws_elb.jenkins_elb.zone_id
    evaluate_target_health = true
  }
}

// Create Jenkins cert
resource "aws_acm_certificate" "jenkins" {
  domain_name = local.jenkins_endpoint
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.jenkins.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.jenkins.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [aws_acm_certificate.jenkins.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "jenkins" {
  certificate_arn         = aws_acm_certificate.jenkins.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn]
}
// End cert validation
