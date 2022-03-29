data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  function_name  = "${terraform.workspace}-${var.function_name}"
  log_group_name = "/aws/lambda/${local.function_name}"
}

########################################################################################################################
## Lambda Function
########################################################################################################################

resource "aws_lambda_function" "main" {
  filename                       = var.zip_file
  function_name                  = local.function_name
  role                           = aws_iam_role.lambda_role.arn
  handler                        = var.lambda_handler
  description                    = var.description
  runtime                        = "ruby2.7"
  source_code_hash               = filebase64sha256(var.zip_file)
  kms_key_arn                    = aws_kms_key.lambda.arn
  timeout                        = var.timeout
  reserved_concurrent_executions = var.concurrency

  tracing_config {
    mode = "Active"
  }

  tags = {
    Name        = "${terraform.workspace}-${var.function_name}"
    Environment = terraform.workspace
  }
}
