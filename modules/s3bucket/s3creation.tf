resource "aws_s3_bucket" "sam_web_bucket" {
  bucket = "sam-web-application-bucket"

  tags = {
    Name = "Sam Web Application Bucket"
  }
}