resource "aws_route53_record" "alb" {
  provider = aws.root_account
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = var.domain_name
  type     = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

