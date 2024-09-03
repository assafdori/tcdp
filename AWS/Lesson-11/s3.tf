resource "aws_s3_bucket" "technion" {
  bucket = "technion-${random_string.bucket-suffix[count.index].result}"
  count = 3 

provisioner "local-exec" {
  command = "touch test.txt"
 }
}

resource "random_string" "bucket-suffix" {
  length  = 8
  special = false
  upper   = false
  count = 3 
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.technion[count.index].bucket
  key    = "test.txt"
  source = "test.txt"
  count = 3
}

output "bucket" {
  value = aws_s3_bucket.technion[*].bucket
}


