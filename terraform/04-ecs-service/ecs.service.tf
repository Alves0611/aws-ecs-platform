resource "aws_ecs_service" "this" {
  for_each = var.services

  name            = each.value.service_name
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.cluster_id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.desired_count

  capacity_provider_strategy {
    base              = var.capacity_provider_base
    weight            = var.capacity_provider_weight
    capacity_provider = var.capacity_provider
  }

  dynamic "load_balancer" {
    for_each = try(data.terraform_remote_state.alb.outputs.target_group_arns[each.key], null) != null ? [1] : []
    content {
      target_group_arn = coalesce(each.value.target_group_arn, try(data.terraform_remote_state.alb.outputs.target_group_arns[each.key], null))
      container_name   = each.value.container_name
      container_port   = each.value.container_port
    }
  }

  network_configuration {
    subnets          = data.aws_subnets.this.ids
    assign_public_ip = each.value.assign_public_ip
    security_groups  = [aws_security_group.ecs_tasks[each.key].id]
  }

  tags = merge(
    var.common_tags,
    {
      Name    = each.value.service_name
      Service = each.key
    }
  )
}
