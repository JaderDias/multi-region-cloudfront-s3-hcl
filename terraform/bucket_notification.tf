resource "aws_lambda_permission" "lambda_s3_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.s3update_function.function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${module.s3website.id}"
}

resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = module.s3website.id
  lambda_function {
    lambda_function_arn = module.s3update_function.function.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [
    aws_lambda_permission.lambda_s3_permission
  ]
}
