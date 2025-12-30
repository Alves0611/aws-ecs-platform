variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "github_repo_subject" {
  description = "GitHub repository subject for OIDC (e.g., 'repo:username/repo-name:*')"
  type        = string
  default     = "repo:Alves0611/aws-ecs-platform:*"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

