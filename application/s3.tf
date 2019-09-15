resource "aws_s3_bucket" "attachment8" {
  bucket = var.bucket_name
  acl = "private"

  tags = {
    Name   = "Atachment 8 resources"
    Author = var.author
    Tool   = local.build_tool
  }
}

resource "aws_s3_bucket_object" "actors" {
  bucket = var.bucket_name
  key = "actor.json"
  source = "${path.module}/resources/actors.json"

  etag = data.archive_file.get_actor_archive.output_md5

  depends_on = [aws_s3_bucket.attachment8]
}