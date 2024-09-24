###########
# Network #
###########


resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"

  tags = {
    Name = "website"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "website"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "website"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public1_association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_association" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}


#######
# EC2 #
#######

resource "aws_security_group" "main" {
  lifecycle {
    ignore_changes = [ description ]
  }
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "website" {
  lifecycle {
    ignore_changes = [ vpc_security_group_ids, user_data]
  }
  count         = 2

  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.main.id]

  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update
                sudo yum install -y docker
                sudo systemctl start docker
                docker run --rm -d -p 8080:8080 --name swagger swaggerapi/swagger-ui
              EOF

  tags = {
    Name = "website-${count.index}"
  }
}

moved {
  from = aws_instance.web
  to   = aws_instance.website[0]
}
