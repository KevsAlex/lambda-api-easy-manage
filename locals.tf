#--------------------------
# OMNIA-API
#---------------------------
locals {

  created-roles = tomap({
    (aws_iam_role.role-basic-lambda.name) = aws_iam_role.role-basic-lambda,
  })

  ##Creates lambda and S3 bucket
  lambda-config = [
  for key, value in local.lambdas : {
    name       = value["name"]
    lambda     = value
    bucketName = (aws_s3_bucket.api-bucket.id),
    bucketKey  = "${value["name"]}/lambda.zip",
    role       = lookup(
      {for keyRole, valueRole in local.created-roles :  keyRole => valueRole},
      value["roleName"],
      "what?")
    resource_path   = value["resource_path"],
    parent_resource = value["parent_resource"],
    method          = value["method"],

  }
  ]

  lambda-api-gw-config = [
  for key, value in local.lambdas : {
    name          = value["name"]
    resource_path = value["resource_path"],
    method        = value["method"],
    authorizer    = value["authorizer"],

    aws_api_gateway_method = value["parent_resource"]

    lambda = lookup(
      {for keylambda, valuelambda in aws_lambda_function.lamdbas :  valuelambda["function_name"] => valuelambda},
      "lambda-myapi-${value["name"]}-${var.environment}",
      "Not found : lambda-myapi-${value["name"]}-${var.environment}")
  }
  ]



}
