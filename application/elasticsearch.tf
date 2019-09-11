resource "aws_elasticsearch_domain" "example" {
  domain_name           = "Attachment8"
  elasticsearch_version = "7.1"

  cluster_config {
    instance_type = "r5.xlarge.elasticsearch"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  advanced_options = {
    "indices.fielddata.cache.size" = "50",
    "rest.action.multi.allow_explicit_index" = "true"
  }

  ebs_options = {
    ebs_enabled = true
    volume_size= 100
    volume_type = "gp2"
  }

  encrypt_at_rest = {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  vpc_options = {
    "availability_zones" = var.availability_zones
    "security_group_ids" = [aws_security_group.elastic_search.id]
    "subnet_ids" = var.private_subnet_ids
    "vpc_id" = var.vpc_id
  }

  tags = {
    Domain = "Attachment8"
  }
}

resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = "${aws_elasticsearch_domain.example.domain_name}"

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:us-east-2:737986169489:domain/attachment8/*"
 "Resource": "${aws_elasticsearch_domain.example.arn}/*"
    }
  ]
}
POLICIES
}