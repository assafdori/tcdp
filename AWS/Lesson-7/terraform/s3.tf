resource "aws_bucket" "mongodb-backup-assafdori" {
  bucket = "mongodb-backup-assafdori"
  acl    = "private"
  enable_versioning = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name = "mongodb-backup-assafdori"
  }
}
