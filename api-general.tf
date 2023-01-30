
resource "aws_api_gateway_rest_api" awesome-api {
  name = "awesome-api"
  description = "api for omnia"
  minimum_compression_size = 0
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id = aws_api_gateway_rest_api.awesome-api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name = var.environment
}

