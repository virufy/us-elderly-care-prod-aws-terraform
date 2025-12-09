# HTTP API Gateway (v2)
# CORS + IAM AUTH + Lambda Integrations

data "aws_region" "current" {}

# 1 HTTP API (CORS Enabled)

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.project}-${var.env}-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"] # tighten later
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = [
      "Content-Type",
      "Authorization",
      "X-Amz-Date",
      "X-Api-Key",
      "X-Amz-Security-Token"
    ]
    max_age = 3600
  }

  tags = {
    Project = var.project
    Env     = var.env
  }
}

# 2 Lambda Integration (AWS_PROXY)

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_invoke_arn   # <– MUST use invoke ARN
  payload_format_version = "2.0"
}

#3 Routes (IAM protected)
# Route 1: POST /process-audio
resource "aws_apigatewayv2_route" "lambda_route_audio" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /process-audio"

  authorization_type = "AWS_IAM"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Route 2: POST /start-execution (Step Functions wrapper)
resource "aws_apigatewayv2_route" "lambda_route_sfn" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /start-execution"

  authorization_type = "AWS_IAM"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 4 Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id = "AllowAPIGW-${var.env}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn              # <– Use Lambda ARN (NOT invoke ARN)
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# 5 CloudWatch Logging
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/http-api/${var.project}-${var.env}"
  retention_in_days = 30

  tags = {
    Project = var.project
    Env     = var.env
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format          = jsonencode({
      requestId      = "$context.requestId"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  default_route_settings {
    data_trace_enabled       = true
    detailed_metrics_enabled = true
    logging_level            = "INFO"
  }
}

