resource "aws_kms_key" "sns" {
  description         = "${terraform.workspace} Lambda KMS Key for SNS"
  is_enabled          = true
  enable_key_rotation = true

  tags = {
    Name        = "${terraform.workspace}-encrypted-sns"
    Environment = terraform.workspace
  }
}

resource "aws_sns_topic" "operational_alerts" {
  name              = "${terraform.workspace}-operational-alerts"
  kms_master_key_id = aws_kms_key.sns.id
}
