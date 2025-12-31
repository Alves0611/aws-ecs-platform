target_groups = {
  "react" = {
    subdomain         = "app"
    port              = 80
    protocol          = "HTTP"
    health_check_path = "/healthz"
  }
  "python-api" = {
    subdomain         = "api-python"
    port              = 8000
    protocol          = "HTTP"
    health_check_path = "/healthz"
  }
  "java-api" = {
    subdomain         = "api-java"
    port              = 8000
    protocol          = "HTTP"
    health_check_path = "/healthz"
  }
}

base_domain       = "gabrielstudying.click"
route53_zone_name = "gabrielstudying.click"

common_tags = {
  ManagedBy = "Terraform"
  Project   = "aws-ecs-platform"
}

