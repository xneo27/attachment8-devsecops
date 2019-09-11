resource "aws_s3_bucket" "attachment8" {
  bucket = var.bucket_name
  acl = "private"

  tags = {
    Name   = "Atachment 8 resources"
    Author = var.author
    Tool   = local.build_tool
  }
}

