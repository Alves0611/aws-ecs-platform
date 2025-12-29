resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  requires_compatibilities = [var.capacity_provider]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.container_name}",
    "image": "${var.container_image}",
    "cpu": ${var.task_cpu},
    "memory": ${var.task_memory},
    "essential": true,
    "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port},
          "protocol": "tcp"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_log_group}",
            "awslogs-region": "${var.region}",
            "awslogs-create-group": "true",
            "awslogs-stream-prefix": "${var.cloudwatch_log_stream_prefix}"
        }
    }
  }
]
TASK_DEFINITION

  tags = var.common_tags
}
