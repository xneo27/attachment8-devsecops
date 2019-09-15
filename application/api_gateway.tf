# @TODO decouple resources between this deployment and those in the api_gateway git project (lambda, terraform gateway , etc). The current build is brittle.


//resource "null_resource" "tmp" {
//  triggers = {
//    ts = "${timestamp()}"
//  }
//
//  provisioner "local-exec" {
//    command = "rm -fr tmp && mkdir tmp && cd tmp"
//  }
//}
//
//# Clone API gateway repo
//resource "null_resource" "api_gateway_resources" {
//  triggers = {
//    ts = "${timestamp()}"
//  }
//
//  provisioner "local-exec" {
//    command = "git clone --branch ${var.api_git_version} ${var.api_git_url}"
//  }
//
//  depends_on = [null_resource.tmp]
//}
//
//# Clone Ingester repo
//resource "null_resource" "ingester_resources" {
//  triggers = {
//    ts = "${timestamp()}"
//  }
//
//  provisioner "local-exec" {
//    command = "git clone --branch ${var.api_git_version} ${var.ingester_get_url}"
//  }
//
//  depends_on = [null_resource.tmp]
//}

data "template_file" "swagger_file" {
  template = file("${path.module}/tmp/attachment8-api/api/swagger.tpl")

  vars = {
    api_version = timestamp()
    get_actor_url = aws_lambda_function.get_actor.invoke_arn
    // TODO Update to correct ECS dns
    get_synopsis_url = "http://EC2Co-EcsEl-1IC59QOL64NJV-1315119122.us-east-2.elb.amazonaws.com:5000"
  }

//  depends_on = [null_resource.api_gateway_resources]
}

resource "aws_api_gateway_rest_api" "Attachment8" {
  name = "attachment8"

  body = data.template_file.swagger_file.rendered
}

resource "aws_api_gateway_api_key" "attachment8_api_key" {
  name = "attachment8-key"
}

resource "aws_api_gateway_usage_plan" "attachment8_usage_plan" {
  name = "basic"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.Attachment8.id}"
    stage  = "${aws_api_gateway_deployment.attachment8_prod_deployment.stage_name}"
  }

  throttle_settings {
    burst_limit = 100
    rate_limit  = 10
  }
}

resource "aws_api_gateway_deployment" "attachment8_prod_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.Attachment8.id}"
  stage_name  = "prod"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.attachment8_api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.attachment8_usage_plan.id}"
}


### GET ACTOR RESOURCES ####
resource "null_resource" "prepare_get_actor" {
  triggers = {
    ts = timestamp()
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/resources/prepare_s3.sh ${path.module}/tmp/attachment8-api/lambda/actor/ lambda_function.py"
  }

//  depends_on = [null_resource.api_gateway_resources]
}

data "archive_file" "get_actor_archive" {
  source_dir = "${path.module}/tmp/attachment8-api/lambda/actor/env/lib/python3.7/site-packages/"
  output_path = "${path.module}/tmp/get_actor.zip"
  type = "zip"

  depends_on = [null_resource.prepare_get_actor]
}


resource "aws_s3_bucket_object" "get_actor" {
  bucket = var.bucket_name
  key = "get_actor.zip"
  source = data.archive_file.get_actor_archive.output_path

  etag = data.archive_file.get_actor_archive.output_md5

  depends_on = [aws_s3_bucket.attachment8]
}

resource "aws_lambda_function" "get_actor" {
  s3_bucket = var.bucket_name
  s3_key = "get_actor.zip"

  function_name = "attachment8-actor"
  role          = aws_iam_role.lambda-es.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"
  memory_size   = "1024"
  timeout       = "60"
  vpc_config {
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.elastic_search.id]
  }
  environment {
    variables = {
      REGION = var.ec2_region
      PORT = 443
      HOST = "${aws_elasticsearch_domain.example.endpoint}"
    }
  }

  source_code_hash = data.archive_file.get_actor_archive.output_base64sha256

  depends_on = [aws_s3_bucket_object.get_actor]
}

resource "aws_lambda_permission" "apigw_lambda_get_actor" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_actor.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.Attachment8.execution_arn}/*/GET/actor"
}




### INGESTER RESOURCES ####
resource "null_resource" "prepare_ingester" {
  triggers = {
    ts = timestamp()
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/resources/ingester_s3.sh ${path.module}/tmp/attachment8-ingesters/ ${aws_elasticsearch_domain.example.endpoint} ${var.ec2_region} ${var.bucket_name}"
  }

//  depends_on = [null_resource.ingester_resources]
}

data "archive_file" "ingester_archive" {
  source_dir = "${path.module}/tmp/attachment8-ingesters/env/lib/python3.7/site-packages/"
  output_path = "${path.module}/tmp/ingester.zip"
  type = "zip"

  depends_on = [null_resource.prepare_ingester]
}

resource "aws_s3_bucket_object" "ingester" {
  bucket = var.bucket_name
  key = "ingester.zip"
  source = data.archive_file.ingester_archive.output_path

  etag = data.archive_file.ingester_archive.output_md5

  depends_on = [aws_s3_bucket.attachment8]
}

resource "aws_lambda_function" "ingester" {
  s3_bucket = var.bucket_name
  s3_key = "ingester.zip"

  function_name = "attachment8-ingesters"
  role          = aws_iam_role.lambda-es.arn
  handler       = "s3_ingester.main"
  runtime       = "python3.6"
  memory_size   = "256"
  timeout       = "60"
  vpc_config {
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.elastic_search.id]
  }
  source_code_hash = data.archive_file.ingester_archive.output_base64sha256
  depends_on = [aws_s3_bucket_object.ingester]
}

data "aws_lambda_invocation" "run_ingester" {
  function_name = aws_lambda_function.ingester.function_name
  input = ""

  depends_on = [aws_lambda_function.ingester]
}