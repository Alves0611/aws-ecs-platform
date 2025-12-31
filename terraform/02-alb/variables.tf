variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "studying"
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "studying-alb"
}

variable "alb_internal" {
  description = "Whether the ALB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}

variable "base_domain" {
  description = "Base domain name (e.g., gabrielstudying.click)"
  type        = string
  default     = "gabrielstudying.click"
}

variable "target_groups" {
  description = "Map of target groups to create, key is the subdomain/service name"
  type = map(object({
    subdomain             = string
    port                  = number
    protocol              = optional(string, "HTTP")
    health_check_path     = optional(string, "/healthz")
    healthy_threshold     = optional(number, 2)
    unhealthy_threshold   = optional(number, 2)
    health_check_timeout  = optional(number, 5)
    health_check_interval = optional(number, 30)
    health_check_matcher  = optional(string, "200")
  }))
  default = {}
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = string
  default     = "443"
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
  default     = "HTTPS"
}

variable "ssl_policy" {
  description = "SSL policy for the ALB listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "route53_zone_name" {
  description = "Route53 zone name for certificate validation"
  type        = string
  default     = "gabrielstudying.click"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
