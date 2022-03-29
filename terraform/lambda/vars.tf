variable "function_name" {}
variable "zip_file" {}
variable "lambda_handler" {}
variable "description" {}
variable "sns_kms_arn" {}
variable "sns_operational_arn" {}
variable "variables" {
  type    = map(string)
  default = {}
}
variable "concurrency" {
  default = -1
}
variable "timeout" {
  default = 300
}
