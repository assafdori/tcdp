resource "aws_ecs_service" "main" {
  name            = "main_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
    security_groups = [aws_security_group.ecs-sg.id]
  }

  tags = {
    Name = "main_service"
  }
}
