resource "aws_api_gateway_rest_api" "Attachment8" {
  name        = "Attachment8"
  description = "Attachment 8 API"
}

resource "aws_api_gateway_resource" "actor" {
  rest_api_id = aws_api_gateway_rest_api.Attachment8.id
  parent_id   = aws_api_gateway_rest_api.Attachment8.root_resource_id
  path_part   = "actor"
}

resource "aws_api_gateway_resource" "recommend" {
  rest_api_id = aws_api_gateway_rest_api.Attachment8.id
  parent_id   = aws_api_gateway_rest_api.Attachment8.root_resource_id
  path_part   = "recommend"
}

resource "aws_api_gateway_resource" "synopsis" {
  rest_api_id = aws_api_gateway_rest_api.Attachment8.id
  parent_id   = aws_api_gateway_rest_api.Attachment8.root_resource_id
  path_part   = "synopsis"
}

resource "aws_api_gateway_method" "get_actor" {
  rest_api_id   = aws_api_gateway_rest_api.Attachment8.id
  resource_id   = aws_api_gateway_resource.actor.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.querystring.name" = true
  }
}

resource "aws_api_gateway_integration" "get_actor" {
  rest_api_id = aws_api_gateway_rest_api.Attachment8.id
  resource_id = aws_api_gateway_resource.actor.id
  http_method = aws_api_gateway_method.get_actor
  integration_http_method = "GET"
  type = "AWS_PROXY"
//  uri                     = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
  uri = "arn:aws:execute-api:us-east-2:737986169489:7m8ylkqam7/*/GET/actor"
}


resource "aws_api_gateway_method" "post_recommend" {
  rest_api_id   = aws_api_gateway_rest_api.Attachment8.id
  resource_id   = aws_api_gateway_resource.recommend.id
  http_method   = "POST"
  authorization = "NONE"

  api_key_required = true

  request_parameters = {
    "method.request.querystring.name" = true
  }
}

resource "aws_api_gateway_integration" "post_recommend" {
  rest_api_id = aws_api_gateway_rest_api.Attachment8.id
  resource_id = aws_api_gateway_resource.actor.id
  http_method = aws_api_gateway_method.post_recommend
  integration_http_method = "POST"
  type = "AWS_PROXY"
  //  uri                     = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
  uri = "arn:aws:execute-api:us-east-2:737986169489:7m8ylkqam7/*/POST/recommend"
}

resource "aws_api_gateway_method" "post_synopsis" {
  rest_api_id   = aws_api_gateway_rest_api.Attachment8.id
  resource_id   = aws_api_gateway_resource.synopsis.id
  http_method   = "POST"
  authorization = "NONE"

  api_key_required = true

  request_parameters = {
    "method.request.querystring.name" = true
  }
}

resource "aws_api_gateway_integration" "post_synopsis" {
  rest_api_id = aws_api_gateway_rest_api.Attachment8.id
  resource_id = aws_api_gateway_resource.actor.id
  http_method = aws_api_gateway_method.post_synopsis
  integration_http_method = "POST"
  type = "AWS_PROXY"
  //  uri                     = "arn:aws:apigateway:${var.myregion}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
  uri = "arn:aws:execute-api:us-east-2:737986169489:7m8ylkqam7/*/POST/synopsis"
}