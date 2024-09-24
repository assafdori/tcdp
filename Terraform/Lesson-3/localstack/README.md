##########
# Deploy #
##########

docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 -d localstack/localstack

or docker-compose up -d

################
# Configure aws #
################
aws configure

AWS Access Key ID [None]: mock_access_key
AWS Secret Access Key [None]: mock_secret_key
Default region name [None]: us-east-1
Default output format [None]: json


############
# Provider #
############

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
  }
}


########
# Test #
########

aws --endpoint-url=http://localhost:4566 ec2 describe-instances
aws --endpoint-url=http://localhost:4566 ec2 describe-vpcs
