resource "aws_instance" "test-instance" {
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.assaf-sg.id]
  subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address = true
}
