#--------------------------
# Manages New Lambdas
#---------------------------
locals {

  lambdas = [

    {
      name          = "awesome-lambda"
      roleName      = "role-basic-lambda-${var.environment}",
      resource_path = "awesome",
      method        = "POST",
      parent_resource = (aws_api_gateway_resource.awesome)
      authorizer    = false,
      create-bucket = false
    },
    {
      name          = "cool-lambda"
      roleName      = "role-basic-lambda-${var.environment}",
      resource_path = "cool",
      method        = "GET",
      parent_resource = (aws_api_gateway_resource.cool)
      authorizer    = false,
      create-bucket = false
    },
    {
      name          = "nice-service"
      roleName      = "role-basic-lambda-${var.environment}",
      resource_path = "nice",
      method        = "GET",
      parent_resource = (aws_api_gateway_resource.api)
      authorizer    = false,
      create-bucket = false
    },
    {
      name          = "better-service"
      roleName      = "role-basic-lambda-${var.environment}",
      resource_path = "better",
      method        = "PUT",
      parent_resource = (aws_api_gateway_resource.api)
      authorizer    = false,
      create-bucket = false
    }

  ]
}
