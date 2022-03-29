########################################################################################################################
## Lambda Role
##
## The role lambda takes when it runs.
########################################################################################################################

data "aws_iam_policy_document" "lambda_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${terraform.workspace}-lambda-${var.function_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

########################################################################################################################
## Lambda Base Permissions
########################################################################################################################

data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "lambda:GetAccountSettings"
    ]
    resources = [
      "*"
    ]
  }

  # Allows to publish to SNS for failures
  statement {
    sid = "SNS"

    actions = [
      "sns:Publish"
    ]

    resources = [
      var.sns_operational_arn,
    ]
  }

  statement {
    sid = "xray"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries"
    ]
    resources = [
      "*"
    ]
  }

  # Allows to access secrets
  statement {
    sid = "KMS"
    actions = [
      "kms:ListKeys",
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      aws_kms_key.lambda.arn,
      var.sns_kms_arn,
    ]
  }

  # Allows to write logs
  statement {
    sid = "Cloudwatch"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    # tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "${aws_cloudwatch_log_group.main.arn}:*"
    ]
  }

  # Allows management of child accounts
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    # tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "arn:aws:iam::*:role/AWSControlTowerExecution"
    ]
  }
}

resource "aws_iam_policy" "main" {
  name   = "${terraform.workspace}-main-${var.function_name}"
  path   = "/"
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.main.arn
}
