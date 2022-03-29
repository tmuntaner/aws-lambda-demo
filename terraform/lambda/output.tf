output "iam_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "function_name" {
  value = aws_lambda_function.main.function_name
}

output "function_arn" {
  value = aws_lambda_function.main.arn
}

output "invoke_arn" {
  value = aws_lambda_function.main.invoke_arn
}

output "qualified_arn" {
  value = aws_lambda_function.main.qualified_arn
}
