module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = true
  

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"
  
  ami                    = "ami-0ebfd941bbafe70c6"
  instance_type          = "t2.micro"
  key_name               = "temp-key"
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg.security_group_id] 
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data = file("user_data.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "swagger-ui"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}





