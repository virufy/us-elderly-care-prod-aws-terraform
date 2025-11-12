resource "aws_apigatewayv2_api" "http" {
    name = "${var.project}-${var.env}-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
    api_id = aws_apigatewayv2_api.http.id
    integration_type = "AWS_PROXY" 
    integration_uri = var.lambda_arn
}

resource "aws_apigatewayv2_route" "default" {
    api_id = aws_apigatewayv2_api.http.id
    route_key = "POST /invoke"
    target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}