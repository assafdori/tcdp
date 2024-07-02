resource "aws_s3_bucket" "technion-s3-bucket" {
  bucket = "technion-s3-bucket-1234567890"
  tags = {
    Name = "technion-s3-bucket"
  }
  
}
