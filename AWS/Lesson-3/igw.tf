resource "aws_internet_gateway" "technion-igw" {
  vpc_id = aws_vpc.technion-vpc.id
  tags = {
    Name = "technion-igw"
  }
}


