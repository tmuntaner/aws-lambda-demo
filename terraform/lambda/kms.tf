########################################################################################################################
## KMS
##
## The KMS key which lambda uses to encrypt its secrets.
########################################################################################################################

resource "aws_kms_key" "lambda" {
  description         = "${terraform.workspace} Lambda KMS Key for Encrypted Secrets"
  is_enabled          = true
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.lambda_kms.json

  tags = {
    Name        = "${terraform.workspace}-lambda-kms-key-${var.function_name}"
    Environment = terraform.workspace
  }
}

data "aws_iam_policy_document" "lambda_kms" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
      type = "AWS"
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }

  # made with inspiration from https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
  statement {
    sid = "allow cloudwatch"

    principals {
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*"
    ]

    condition {
      test     = "ArnEquals"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.log_group_name}"]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }
}
