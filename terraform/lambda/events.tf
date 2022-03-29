########################################################################################################################
## Lambda Invoke Chain
##
## Sets sends alerts to operational SNS if failure
########################################################################################################################

resource "aws_lambda_function_event_invoke_config" "failure" {
  function_name = aws_lambda_function.main.function_name

  destination_config {
    on_failure {
      destination = var.sns_operational_arn
    }
  }
}
