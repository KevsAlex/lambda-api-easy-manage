resource "aws_api_gateway_resource" api {
  rest_api_id = aws_api_gateway_rest_api.awesome-api.id
  parent_id   = aws_api_gateway_rest_api.awesome-api.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" awesome {
  rest_api_id = aws_api_gateway_rest_api.awesome-api.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "awesome"
}

resource "aws_api_gateway_resource" cool {
  rest_api_id = aws_api_gateway_rest_api.awesome-api.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "cool"
}