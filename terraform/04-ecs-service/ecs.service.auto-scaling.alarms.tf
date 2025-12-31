resource "aws_cloudwatch_metric_alarm" "scale_down" {
  for_each = aws_appautoscaling_target.ecs

  alarm_name                = "${each.key}-scale-down"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = var.autoscaling_scale_down_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.autoscaling_metric_period
  statistic                 = "Average"
  threshold                 = var.services[each.key].autoscaling_scale_down_threshold
  alarm_description         = "This metric monitors ECS Service ${each.key} CPU utilization for scale down"
  insufficient_data_actions = []
  alarm_actions             = [aws_appautoscaling_policy.scale_down[each.key].arn]

  dimensions = {
    ClusterName = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
    ServiceName = aws_ecs_service.this[each.key].name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  for_each = aws_appautoscaling_target.ecs

  alarm_name                = "${each.key}-scale-up"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.autoscaling_scale_up_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.autoscaling_metric_period
  statistic                 = "Average"
  threshold                 = var.services[each.key].autoscaling_scale_up_threshold
  alarm_description         = "This metric monitors ECS Service ${each.key} CPU utilization for scale up"
  insufficient_data_actions = []
  alarm_actions             = [aws_appautoscaling_policy.scale_up[each.key].arn]

  dimensions = {
    ClusterName = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
    ServiceName = aws_ecs_service.this[each.key].name
  }
}
