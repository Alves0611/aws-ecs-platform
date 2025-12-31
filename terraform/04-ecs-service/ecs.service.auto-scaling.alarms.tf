resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name                = "${var.autoscaling_alarm_name_prefix}scale-down"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = var.autoscaling_scale_down_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.autoscaling_metric_period
  statistic                 = "Average"
  threshold                 = var.autoscaling_scale_down_threshold
  alarm_description         = "This metric monitors ECS Service cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_appautoscaling_policy.scale_down.arn]

  dimensions = {
    ClusterName = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
    ServiceName = aws_ecs_service.this.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name                = "${var.autoscaling_alarm_name_prefix}scale-up"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.autoscaling_scale_up_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.autoscaling_metric_period
  statistic                 = "Average"
  threshold                 = var.autoscaling_scale_up_threshold
  alarm_description         = "This metric monitors ECS Service cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_appautoscaling_policy.scale_up.arn]

  dimensions = {
    ClusterName = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
    ServiceName = aws_ecs_service.this.name
  }
}
