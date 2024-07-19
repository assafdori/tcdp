resource "aws_autoscaling_group" "asg" {
  name                      = "asg"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true

  target_group_arns = [aws_alb_target_group.alb-tg.arn]

  launch_template {
    id      = aws_launch_template.technion-launch-template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id,
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tag {
    key                 = "Name"
    value               = "asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.alb]
}

resource "aws_launch_template" "technion-launch-template" {
  name = "technion-launch-template"
  image_id = "ami-07fa59ce6da2fe3fe"
  instance_type = "t4g.nano"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.sg.id]
    subnet_id = aws_subnet.public-subnet-1.id
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "technion-website-instance"
    }
  }


  user_data = base64encode(<<-EOF
   #!/bin/bash
   sudo yum update -y
   sudo yum install -y nginx python3 python3-pip
   sudo systemctl start nginx
   sudo systemctl enable nginx
   echo "<h1>Deployed via Terraform with Nginx on $(hostname)</h1>" | sudo tee /usr/share/nginx/html/index.html
   EOF
   )

  tags = {
    Name = "technion-launch-template"
  }
}
