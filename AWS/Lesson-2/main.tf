provider "aws" {
 region = "us-east-1"
}

resource "tls_private_key" "technion-demo-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "technion-demo-key-pair" {
  key_name = "technion-demo-key-pair"
  public_key = tls_private_key.technion-demo-key.public_key_openssh
}

resource "aws_s3_bucket" "technion-demo-bucket" {
  bucket = "technion-demo-bucket-123456789"
}

resource "aws_vpc" "technion-demo-vpc" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "technion-demo-subnet" {
  vpc_id = aws_vpc.technion-demo-vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_instance" "technion-demo" {
 ami = "ami-0e90165acf703dc49"
 instance_type = "t4g.micro"
 vpc_security_group_ids = [aws_security_group.technion-demo-sg.id]
 key_name = aws_key_pair.technion-demo-key-pair.key_name
 subnet_id = aws_subnet.technion-demo-subnet.id
 associate_public_ip_address = true
}

resource "aws_security_group" "technion-demo-sg" {
  name = "technion-demo-sg"
  vpc_id = aws_vpc.technion-demo-vpc.id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
