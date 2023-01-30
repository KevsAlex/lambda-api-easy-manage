#--------------------------
# Manages Deployment
#---------------------------

#api-method
resource "aws_api_gateway_method" "api_method" {
  for_each         = {
  for lambda in local.lambda-api-gw-config :  lambda["name"] => lambda
  }
  rest_api_id      = aws_api_gateway_rest_api.awesome-api.id
  resource_id      = each.value["aws_api_gateway_method"]["id"]
  http_method      = each.value["method"]
  authorization    = each.value["authorizer"] ? "CUSTOM" :"NONE"
  //authorizer_id    = each.value["authorizer"] ? aws_api_gateway_authorizer.bhsf_exp_authorizer_node.id : null
  api_key_required = false
}

#api-integration
resource "aws_api_gateway_integration" "api-integration" {
  for_each    = {
  for lambda in local.lambda-api-gw-config :  lambda["name"] => lambda
  }
  rest_api_id = aws_api_gateway_rest_api.awesome-api.id
  resource_id = each.value["aws_api_gateway_method"]["id"]

  http_method = each.value["method"]
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = each.value["lambda"]["invoke_arn"]
  content_handling        = "CONVERT_TO_TEXT"

  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters      = {}
  request_templates       = {}

  depends_on              = [
    aws_api_gateway_method.api_method
  ]
}

//API PERMISSION
resource "aws_lambda_permission" "api-permissions" {
  for_each      = {
  for lambda in local.lambda-api-gw-config :  lambda["name"] => lambda
  }
  statement_id  = "AllowOmniaGatewayInvokeExp"
  action        = "lambda:InvokeFunction"
  function_name = each.value["lambda"]["function_name"]
  //function_name = each.value["path"]
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.awesome-api.execution_arn}/*/*"
}

//SPECIFIC PERMISSIONS
resource "aws_lambda_permission" "aditional-api-permissions" {
  for_each      = {
  for lambda in local.lambda-api-gw-config :  lambda["name"] => lambda
  }
  statement_id  = "InvokeOmniaPermission"
  action        = "lambda:InvokeFunction"
  function_name = each.value["lambda"]["function_name"]
  //function_name = each.value["path"]
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.awesome-api.execution_arn}/*/${each.value["method"]}${each.value["aws_api_gateway_method"]["path"]}"
}

resource "aws_api_gateway_deployment" "deployment" {
  stage_description = "${var.environment} deployment"
  rest_api_id = aws_api_gateway_rest_api.awesome-api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.api_method,
      aws_api_gateway_integration.api-integration
    ]))
  }

  #force redeployment
  #variables = {
  #  deployed_at = "${timestamp()}"
  #}

  lifecycle {
    create_before_destroy = true
  }
}