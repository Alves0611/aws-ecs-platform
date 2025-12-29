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

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "python-api-tg"
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 8000
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/healthz"
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks required"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks required"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "HTTP codes to use when checking for a successful response"
  type        = string
  default     = "200"
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

variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
  default     = "gabrielstudying.click"
}

variable "certificate_name" {
  description = "Name tag for the ACM certificate"
  type        = string
  default     = "studying-certificate"
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
