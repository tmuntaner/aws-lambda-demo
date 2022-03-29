########################################################################################################################
## Cloudwatch Logs
##
## The main log group where lambda stores its logs.
########################################################################################################################

resource "aws_cloudwatch_log_group" "main" {
  name              = local.log_group_name
  kms_key_id        = aws_kms_key.lambda.arn
  retention_in_days = 90

  tags = {
    Name        = "${terraform.workspace}-${var.function_name}"
    Environment = terraform.workspace
  }
}
