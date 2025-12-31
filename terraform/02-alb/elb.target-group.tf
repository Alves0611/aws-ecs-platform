resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = "${each.key}-tg"
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = "ip"
  vpc_id      = data.aws_vpc.this.id

  health_check {
    path                = each.value.health_check_path
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    timeout             = each.value.health_check_timeout
    interval            = each.value.health_check_interval
    matcher             = each.value.health_check_matcher
    protocol            = each.value.protocol
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "${each.key}-tg"
      Service = each.key
    }
  )
}
