resource "aws_s3_bucket" "technion-s3-bucket" {
  bucket = "technion-s3-bucket-1234567890"
  tags = {
    Name        = "technion-s3-bucket-1234567890"
    Environment = "technion"
  }
}

resource "aws_s3_bucket_versioning" "technion-s3-bucket-versioning" {
  bucket = aws_s3_bucket.technion-s3-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "technion-s3-bucket-public" {
  bucket = aws_s3_bucket.technion-s3-bucket.bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.technion-s3-bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.technion-s3-bucket.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "technion-s3-bucket-website" {
  bucket = aws_s3_bucket.technion-s3-bucket.bucket
  index_document {
    suffix = "index.html"
  } 
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.technion-s3-bucket.id
  key          = "index.html"
  content      = file("${path.module}/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.technion-s3-bucket.id
  key          = "error.html"
  content      = file("${path.module}/error.html")
  content_type = "text/html"
}

output "website_endpoint" {
  value = aws_s3_bucket.technion-s3-bucket.website_endpoint
}

output "website_endpoint-2" {
  value = aws_s3_bucket_website_configuration.technion-s3-bucket-website.website_endpoint
}
