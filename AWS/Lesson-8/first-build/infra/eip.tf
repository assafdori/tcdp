resource "aws_eip" "main" {

	tags = {
		Name = "main-eip"
	}
}
