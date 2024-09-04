provider "aws" {
  region = "eu-west-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "team4-state" {
  bucket = "team4-state"  # Replace with a unique bucket name
  acl    = "private"
  force_destroy = true
  tags = {
    Name = "team4-state"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.team4-state.id

  versioning_configuration {
    status = "Enabled"
  }
}
