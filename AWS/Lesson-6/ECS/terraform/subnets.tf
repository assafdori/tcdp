resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.technion_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
	Name = "public-subnet-1"
}
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.technion_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
	Name = "public-subnet-2"
}
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.technion_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

  tags = {
	Name = "private-subnet-1"
		}
	}

resource "aws_subnet" "private-subnet-2" {
	vpc_id = aws_vpc.technion_vpc.id
	cidr_block = "10.0.4.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-east-1b"

	tags = {
		Name = "private-subnet-2"
	}
}