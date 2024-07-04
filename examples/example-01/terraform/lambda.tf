// Define the Lambda function to resize images
resource "aws_lambda_function" "ResizeImage" {
  filename         = "../functions/ResizeImage/lambda_function.zip"  // Path to your zip file
  function_name    = "ResizeImage"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  memory_size      = 256
  timeout          = 60
}

// Allow S3 to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ResizeImage.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::resize-image-demo-ns"
}

// Configure S3 bucket notification to trigger Lambda function
resource "aws_s3_bucket_notification" "original_notification" {
  bucket = aws_s3_bucket.image_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.ResizeImage.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_prefix       = "original/"
  }
}