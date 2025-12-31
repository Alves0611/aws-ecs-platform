output "services" {
  description = "Map of service names to their service names"
  value = {
    for k, v in aws_ecs_service.this : k => v.name
  }
}

output "task_definitions" {
  description = "Map of service names to their task definition ARNs"
  value = {
    for k, v in aws_ecs_task_definition.this : k => v.arn
  }
}

output "security_groups" {
  description = "Map of service names to their security group IDs"
  value = {
    for k, v in aws_security_group.ecs_tasks : k => v.id
  }
}

output "execution_role_arn" {
  description = "ARN of the shared ECS task execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

