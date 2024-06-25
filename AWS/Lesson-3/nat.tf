resource "aws_nat_gateway" "technion-ngw" {
  allocation_id = aws_eip.technion-eip.id
  subnet_id     = aws_subnet.technion-public-subnet.id
  
  tags = {
    Name = "technion-ngw"
  }  
}


