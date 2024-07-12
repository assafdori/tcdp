output "ecs_cluster_name" {
	value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
	value = aws_ecs_service.main.name
}

output "ecs_task_definition_family" {
	value = aws_ecs_task_definition.main.family
}

output "ecs_task_definition_arn" {
	value = aws_ecs_task_definition.main.arn
}

