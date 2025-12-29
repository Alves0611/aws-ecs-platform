variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "repositories" {
  description = "Map of ECR repositories to create"
  type = map(object({
    image_tag_mutability = string
    scan_on_push         = bool
    encryption_type      = string
    lifecycle_policy     = string
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to apply to all ECR repositories"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

