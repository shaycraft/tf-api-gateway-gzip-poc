output "function_arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "source_code_hash" {
  value = aws_lambda_function.lambda_function.source_code_hash
}