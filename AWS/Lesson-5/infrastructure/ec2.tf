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
              sudo apt-get install -y nginx python3 python3-pip
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Deployed via Terraform with Nginx</h1>" | sudo tee /var/www/html/index.html
              
              # Install Docker
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
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
              sudo apt-get install -y nginx python3 python3-pip
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Deployed via Terraform with Nginx</h1>" | sudo tee /var/www/html/index.html
              
              # Install Docker
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF
  
}
