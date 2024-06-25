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


