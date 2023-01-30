resource "aws_s3_bucket" "api-bucket" {

  bucket = "s3-my-awsome-api-${var.environment}"
}


data archive_file source {
  type        = "zip"
  source_file  = "${path.module}/lambdaCode/index.js"
  output_path = "${path.module}/lambdaCode/lambda.zip"
}

resource "aws_s3_bucket_object" "lambda_code" {
  for_each = {
  for lambda in local.lambdas :  lambda["name"] => lambda
  }
  bucket     = aws_s3_bucket.api-bucket.id
  key        = "${each.key}/lambda.zip"
  acl           = "private"
  server_side_encryption = "aws:kms"
  source     = data.archive_file.source.output_path
  depends_on = [aws_s3_bucket.api-bucket]


}

resource "aws_s3_bucket_object" "lambda_code_hash" {
  for_each = {
  for lambda in local.lambdas :  lambda["name"] => lambda
  }
  bucket     = aws_s3_bucket.api-bucket.id
  key        = "${each.key}/lambda.zip.base64sha256"
  acl           = "private"
  server_side_encryption = "aws:kms"
  source     = data.archive_file.source.output_path
  depends_on = [aws_s3_bucket.api-bucket]
}