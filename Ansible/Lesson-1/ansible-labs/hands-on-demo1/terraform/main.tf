provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-internet-gateway"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group to allow SSH and HTTP
resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allows all outbound traffic
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Ansible Controller Instance
resource "aws_instance" "ansible_controller" {
  ami               = "ami-0583d8c7a9c35822c"  # rhel 9 AMI for us-east-1
  instance_type     = "t2.small"
  key_name          = "ssh-key-resume-server"
  security_groups   = [aws_security_group.allow_ssh.id]
  subnet_id         = aws_subnet.public_subnet.id
  iam_instance_profile = aws_iam_instance_profile.ansible_profile.name

  user_data = <<-EOF
            #!/bin/bash
            sudo dnf install ansible-core -y || { echo 'Ansible installation failed' > /tmp/ansible_install_error.log; exit 1; }
            sudo dnf install -y git || { echo 'Git installation failed' > /tmp/git_install_error.log; exit 1; }
            # Clone the public repository
            git clone https://github.com/tpaz1/ansible-labs.git /home/ec2-user/ansible-labs || { echo 'Git clone failed' > /tmp/git_clone_error.log; exit 1; }
            sudo chown -R ec2-user:ec2-user /home/ec2-user/ansible-labs
            EOF

  tags = {
    Name = "ansible-controller"
  }
}

# Ansible Worker Instances
resource "aws_instance" "ansible_workers" {
  count             = 3
  ami               = "ami-0583d8c7a9c35822c"  # CentOS 7 AMI for us-east-1
  instance_type     = "t2.small"
  key_name          = "ssh-key-resume-server"
  security_groups   = [aws_security_group.allow_ssh.id]
  subnet_id         = aws_subnet.public_subnet.id
  iam_instance_profile = aws_iam_instance_profile.ansible_profile.name

  tags = {
    Name = "ansible-worker-${count.index + 1}"
  }
}


# Output

output "ansible_controller_public_ip" {
  value = aws_instance.ansible_controller.public_ip
}

output "ansible_workers_public_ips" {
  value = [for instance in aws_instance.ansible_workers : instance.public_ip]
}

# IAM Policy to allow Ansible dynamic inventory access
resource "aws_iam_policy" "ansible_ec2_inventory_policy" {
  name        = "AnsibleEC2InventoryPolicy"
  description = "Policy to allow Ansible dynamic inventory for EC2"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for EC2 Instances
resource "aws_iam_role" "ansible_ec2_inventory_role" {
  name               = "AnsibleEC2InventoryRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ansible_role_policy_attachment" {
  policy_arn = aws_iam_policy.ansible_ec2_inventory_policy.arn
  role       = aws_iam_role.ansible_ec2_inventory_role.name
}


# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ansible_profile" {
  name = "AnsibleEC2InventoryInstanceProfile"
  role = aws_iam_role.ansible_ec2_inventory_role.name
}
