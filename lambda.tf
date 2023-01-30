#--------------------------
# Lambdas
#---------------------------
resource "aws_lambda_function" "lamdbas" {
  for_each = {
  for lambda in local.lambda-config :  lambda["name"] => lambda
  }
  function_name = "lambda-myapi-${each.key}-${var.environment}"

  s3_bucket = each.value["bucketName"]
  s3_key    = each.value["bucketKey"]

  runtime = "nodejs14.x"
  handler = "index.handler"
  timeout = 30
  role    = each.value["role"]["arn"]


  environment {
    variables = {
      environment = var.environment
    }
  }
  depends_on = [
    aws_s3_bucket_object.lambda_code,
    aws_s3_bucket_object.lambda_code_hash,
  ]

}