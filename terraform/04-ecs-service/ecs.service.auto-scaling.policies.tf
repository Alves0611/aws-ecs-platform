resource "aws_appautoscaling_target" "ecs" {
  for_each = {
    for k, v in var.services : k => v
    if v.autoscaling_enabled
  }

  max_capacity       = each.value.autoscaling_max_capacity
  min_capacity       = each.value.autoscaling_min_capacity
  resource_id        = "service/${data.terraform_remote_state.ecs_cluster.outputs.cluster_name}/${aws_ecs_service.this[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_down" {
  for_each = aws_appautoscaling_target.ecs

  name               = "${each.key}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = each.value.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.autoscaling_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.autoscaling_scale_down_adjustment
    }
  }
}

resource "aws_appautoscaling_policy" "scale_up" {
  for_each = aws_appautoscaling_target.ecs

  name               = "${each.key}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = each.value.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.autoscaling_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.autoscaling_scale_up_adjustment
    }
  }
}
