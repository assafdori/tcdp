resource "aws_ecs_task_definition" "main" {
  family                   = "main_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "technion-nginx"
    image = "nginx:latest"
    essential = true

    portMappings = [{
      containerPort = 80
      hostPort      = 80

    }]
  }])

  tags = {
    Name = "main_task_definition"
  }
}
