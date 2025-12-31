resource "aws_security_group" "ecs_tasks" {
  for_each = var.services

  name        = each.value.security_group_name
  description = "Security group for ECS tasks ${each.key} to allow traffic from ALB"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description     = "Allow traffic from ALB on port ${each.value.container_port}"
    from_port       = each.value.container_port
    to_port         = each.value.container_port
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.alb.outputs.security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name    = each.value.security_group_name
      Service = each.key
    }
  )
}
