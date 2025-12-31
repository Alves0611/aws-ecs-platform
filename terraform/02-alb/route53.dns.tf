resource "aws_route53_record" "alb_subdomains" {
  for_each = var.target_groups

  provider = aws.root_account
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = "${each.value.subdomain}.${var.base_domain}"
  type     = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
