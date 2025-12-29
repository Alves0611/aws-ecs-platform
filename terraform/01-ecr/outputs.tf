output "repository_urls" {
  description = "Map of repository names to their repository URLs"
  value = {
    for k, v in aws_ecr_repository.this : k => v.repository_url
  }
}

output "repository_arns" {
  description = "Map of repository names to their ARNs"
  value = {
    for k, v in aws_ecr_repository.this : k => v.arn
  }
}

output "repository_registry_ids" {
  description = "Map of repository names to their registry IDs"
  value = {
    for k, v in aws_ecr_repository.this : k => v.registry_id
  }
}

