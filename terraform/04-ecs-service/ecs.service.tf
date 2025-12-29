resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  capacity_provider_strategy {
    base              = var.capacity_provider_base
    weight            = var.capacity_provider_weight
    capacity_provider = var.capacity_provider
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.alb.outputs.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = data.aws_subnets.this.ids
    assign_public_ip = var.assign_public_ip
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  tags = var.common_tags
}
