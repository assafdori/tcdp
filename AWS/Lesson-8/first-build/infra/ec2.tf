# resource "aws_instance" "mysql-db" {
# 	ami = "ami-0427090fd1714168b"
# 	instance_type = "t3.micro"
# 	subnet_id = aws_subnet.private.id
# 	vpc_security_group_ids = [aws_security_group.mysqldb.id]
# 	key_name = "vockey"
# 
# 	ebs_block_device {
# 		delete_on_termination = true
# 		device_name = "/dev/sdf"
# 		volume_size = 10
# 		volume_type = "gp2"
# 	}
# 	tags = {
# 		Name = "mysql-db"
# 	}
# 	user_data = file("db-userdata.sh")
# }
# 
# resource "aws_instance" "mysql-ui" {
# 	ami = "ami-0427090fd1714168b"
# 	instance_type = "t3.micro"
# 	subnet_id = aws_subnet.public.id
# 	vpc_security_group_ids = [aws_security_group.mysqlui.id]
# 	key_name = "vockey"
# 
# 	tags = {
# 		Name = "mysql-ui"
# 	}
# 	user_data = file("ui-userdata.sh")
# }
