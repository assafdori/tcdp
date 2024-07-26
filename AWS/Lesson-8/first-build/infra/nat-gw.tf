resource "aws_nat_gateway" "main" {
	subnet_id = aws_subnet.public.id
	allocation_id = aws_eip.main.id
	tags = {
		Name = "main-nat-gw"
	}
}
