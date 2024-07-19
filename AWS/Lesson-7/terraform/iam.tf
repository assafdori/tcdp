resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "ecs_task_execution_role"
  }
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs_task_execution_policy_attachment"
  roles      = [aws_iam_role.ecsTaskExecutionRole.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
