resource "aws_security_group" "ecs_tasks" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description     = "Allow traffic from ALB on port ${var.security_group_port}"
    from_port       = var.security_group_port
    to_port         = var.security_group_port
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
      Name = var.security_group_name
    }
  )
}
