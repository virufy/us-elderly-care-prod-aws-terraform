output "http_api_endpoint" {
  description = "Base URL of the HTTP API"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "process_audio_url" {
  description = "POST /process-audio endpoint"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/process-audio"
}

output "start_execution_url" {
  description = "POST /start-execution endpoint"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/start-execution"
}

