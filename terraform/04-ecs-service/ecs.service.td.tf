resource "aws_ecs_task_definition" "this" {
  for_each = var.services

  family                   = each.value.task_family
  requires_compatibilities = [var.capacity_provider]
  network_mode             = "awsvpc"
  cpu                      = each.value.task_cpu
  memory                   = each.value.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${each.value.container_name}",
    "image": "${each.value.container_image}",
    "cpu": ${each.value.task_cpu},
    "memory": ${each.value.task_memory},
    "essential": true,
    "portMappings": [
        {
          "containerPort": ${each.value.container_port},
          "hostPort": ${each.value.container_port},
          "protocol": "tcp"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${each.value.cloudwatch_log_group}",
            "awslogs-region": "${var.region}",
            "awslogs-create-group": "true",
            "awslogs-stream-prefix": "${var.cloudwatch_log_stream_prefix}"
        }
    }
  }
]
TASK_DEFINITION

  tags = merge(
    var.common_tags,
    {
      Name    = each.value.task_family
      Service = each.key
    }
  )
}
