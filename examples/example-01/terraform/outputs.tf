// Output the name of the S3 bucket and the Lambda function ARN
output "bucket_name" {
  value = aws_s3_bucket.image_bucket.bucket
}

output "lambda_function_arn" {
  value = aws_lambda_function.ResizeImage.arn
}
