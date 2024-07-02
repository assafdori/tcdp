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


