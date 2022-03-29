provider "aws" {
  region  = "eu-central-1"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "hello_world" {
  source = "./lambda"

  description    = "Hello World AWS Lambda Function"
  function_name  = "hello_world"
  lambda_handler = "app/lambda_entrypoint.hello_world"

  sns_operational_arn = aws_sns_topic.operational_alerts.arn
  sns_kms_arn         = aws_kms_key.sns.arn
  zip_file            = "lambda_functions.zip"
}

module "greeter" {
  source = "./lambda"

  description    = "Greeter AWS Lambda Function"
  function_name  = "greeter"
  lambda_handler = "app/lambda_entrypoint.greeter"

  sns_operational_arn = aws_sns_topic.operational_alerts.arn
  sns_kms_arn         = aws_kms_key.sns.arn
  zip_file            = "lambda_functions.zip"
}
