# @TODO decouple resources between this deployment and those in the api_gateway git project (lambda, terraform gateway , etc). The current build is brittle.

# Clone API gateway repo
resource "null_resource" "api_gateway_resources" {
  triggers = {
    ts = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "rm -fr tmp && mkdir tmp && cd tmp && git clone --branch ${var.api_git_version} ${var.api_git_url}"
  }
}

data "template_file" "swagger_file" {
  template = file("${path.module}/tmp/attachment8-api/api/swagger.tpl")

  vars = {
    api_version = timestamp()
    get_actor_uri = aws_lambda_function.get_actor.invoke_arn
    post_synopsis_uri = aws_lambda_function.post_synopsis.invoke_arn
  }

  depends_on = [null_resource.api_gateway_resources]
}

resource "aws_api_gateway_rest_api" "Attachment8" {
  name = "Attachment8"

  body = data.template_file.swagger_file.rendered
}


data "aws_iam_role" "lambda_role" {
  name = "lambda-es"
}

# @TODO Correct the details below, then use it instead.
//resource "aws_iam_role" "iam_for_lambda" {
//  name = "iam_for_lambda"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "Service": "lambda.amazonaws.com"
//      },
//      "Effect": "Allow",
//      "Sid": ""
//    }
//  ]
//}
//EOF
//}



### GET ACTOR RESOURCES ####
resource "null_resource" "prepare_get_actor" {
  triggers {
    ts = timestamp()
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/resources/prepare_s3.sh ${path.module}/tmp/attachment8-api/lambda/actor/ lambda_function.py"
  }

  depends_on = [null_resource.api_gateway_resources]
}

data "archive_file" "get_actor_archive" {
  source_file = "${path.module}/tmp/attachment8-api/lambda/actor/env/lib/python3.7/site-packages/"
  output_path = "${path.module}/tmp/get_actor.zip"
  type = "zip"

  depends_on = [null_resource.prepare_get_actor]
}

resource "aws_s3_bucket_object" "get_actor" {
  bucket = var.bucket_name
  key = "get_actor.zip"
  source = data.archive_file.get_actor_archive.output_path

  etag = data.archive_file.get_actor_archive.output_md5
}

resource "aws_lambda_function" "get_actor" {
  s3_bucket = var.bucket_name
  s3_key = aws_s3_bucket_object.get_actor.key

  function_name = "attachment8-actor"
  role          = data.aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"

  source_code_hash = data.archive_file.get_actor_archive.output_base64sha256
}

resource "aws_lambda_permission" "apigw_lambda_get_actor" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_actor.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Attachment8.execution_arn}/*/GET/actor"
}



### POST SYNOPSIS RESOURCES ###
resource "null_resource" "prepare_post_synopsis" {
  triggers {
    ts = timestamp()
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/resources/prepare_s3.sh ${path.module}/tmp/attachment8-api/lambda/synopsis/ synopsis.py"
  }

  depends_on = [null_resource.api_gateway_resources]
}

data "archive_file" "post_synopsis_archive" {
  source_file = "${path.module}/tmp/attachment8-api/lambda/synopsis/env/lib/python3.7/site-packages/"
  output_path = "${path.module}/tmp/post_synopsis.zip"
  type = "zip"

  depends_on = [null_resource.prepare_post_synopsis]
}

resource "aws_s3_bucket_object" "post_synopsis" {
  bucket = var.bucket_name
  key = "post_synopsis.zip"
  source = data.archive_file.post_synopsis_archive.output_path

  etag = data.archive_file.post_synopsis_archive.output_md5
}

resource "aws_lambda_function" "post_synopsis" {
  s3_bucket = var.bucket_name
  s3_key = aws_s3_bucket_object.post_synopsis.key

  function_name = "attachment8-synopsis"
  role          = data.aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"

  source_code_hash = data.archive_file.post_synopsis_archive.output_base64sha256
}

resource "aws_lambda_permission" "apigw_lambda_post_synopsis" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.post_synopsis.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Attachment8.execution_arn}/*/POST/synopsis"
}


