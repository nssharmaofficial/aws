// Create the S3 bucket with two folders: original and resized
resource "aws_s3_bucket" "image_bucket" {
  bucket = "resize-image-demo-ns"
}

// Create the folders within the bucket
resource "aws_s3_object" "original_folder" {
  bucket = aws_s3_bucket.image_bucket.bucket
  key    = "original/"
}

resource "aws_s3_object" "resized_folder" {
  bucket = aws_s3_bucket.image_bucket.bucket
  key    = "resized/"
}

