resource "aws_acm_certificate" "this" {
  domain_name               = var.base_domain
  subject_alternative_names = [for tg in var.target_groups : "${tg.subdomain}.${var.base_domain}"]
  validation_method         = "DNS"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.base_domain}-cert"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
