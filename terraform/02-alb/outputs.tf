output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "Map of service names to their target group ARNs"
  value = {
    for k, v in aws_lb_target_group.this : k => v.arn
  }
}

output "target_group_names" {
  description = "Map of service names to their target group names"
  value = {
    for k, v in aws_lb_target_group.this : k => v.name
  }
}

output "listener_arn" {
  description = "ARN of the ALB HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb.id
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "base_domain" {
  description = "Base domain name"
  value       = var.base_domain
}
