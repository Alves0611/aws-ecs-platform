resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = "application"
  subnets            = data.aws_subnets.this.ids
  security_groups    = [aws_security_group.alb.id]

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = var.alb_name
    }
  )
}
