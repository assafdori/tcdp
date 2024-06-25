provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "technion-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "technion-vpc"
  }
}

resource "aws_internet_gateway" "technion-igw" {
  vpc_id = aws_vpc.technion-vpc.id
  tags = {
    Name = "technion-igw"
  }
}

resource "aws_eip" "technion-eip" {
  tags = {
    Name = "technion-eip"
}
}

resource "aws_nat_gateway" "technion-ngw" {
  allocation_id = aws_eip.technion-eip.id
  subnet_id     = aws_subnet.technion-public-subnet.id
  
  tags = {
    Name = "technion-ngw"
  }  
}

resource "aws_route_table" "technion-public-rt" {
  vpc_id = aws_vpc.technion-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.technion-igw.id
  }
  tags = {
    Name = "technion-public-rt"
  }
}

resource "aws_route_table" "technion-private-rt" {
  vpc_id = aws_vpc.technion-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.technion-ngw.id
  }
  tags = {
    Name = "technion-private-rt"
  }
  
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.technion-public-subnet.id
  route_table_id = aws_route_table.technion-public-rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.technion-private-subnet.id
  route_table_id = aws_route_table.technion-private-rt.id
}

resource "aws_subnet" "technion-public-subnet" {
  vpc_id            = aws_vpc.technion-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "technion-public-subnet"
  }
}

resource "aws_subnet" "technion-private-subnet" {
  vpc_id            = aws_vpc.technion-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "technion-private-subnet"
  }
}

resource "aws_security_group" "technion-security-group" {
  name   = "technion-security-group"
  vpc_id = aws_vpc.technion-vpc.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "technion-security-group"
  }
}

resource "aws_security_group" "technion-security-group-private" {
  name   = "technion-security-group-private"
  vpc_id = aws_vpc.technion-vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "technion-security-group-private"
  }
  
}

resource "aws_instance" "technion-instance-public" {
  ami                         = "ami-08012c0a9ee8e21c4"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.technion-security-group.id]
  subnet_id                   = aws_subnet.technion-public-subnet.id
  key_name                    = "technion-key"
  associate_public_ip_address = true
  tags = {
    Name = "technion-instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Deployed via Terraform with Nginx</h1>" | sudo tee /var/www/html/index.html
              EOF
}

resource "aws_instance" "technion-instance-private" {
  ami                         = "ami-08012c0a9ee8e21c4"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.technion-security-group-private.id]
  subnet_id                   = aws_subnet.technion-private-subnet.id
  key_name                    = "technion-key"
  associate_public_ip_address = false
  tags = {
    Name = "technion-instance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Deployed via Terraform with Nginx</h1>" | sudo tee /var/www/html/index.html
              EOF
  
}

output "public_ip" {
  value = aws_instance.technion-instance-public.public_ip
}

output "private_ip" {
  value = aws_instance.technion-instance-private.private_ip
}
