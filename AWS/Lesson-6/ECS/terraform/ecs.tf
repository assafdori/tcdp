resource "aws_ecs_cluster" "ecs_cluster" {
	name = "ecs_cluster"
  
	tags = {
		Name = "ecs_cluster"
	}
}
