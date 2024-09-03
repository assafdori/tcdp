terraform {
  backend "s3" {
    bucket = "assaf-terraform"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
