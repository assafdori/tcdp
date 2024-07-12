resource "aws_eip" "eip" {
  tags = {
    Name = "eip"
  }
}
