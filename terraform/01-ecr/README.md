## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.27.0 |


## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to all ECR repositories | `map(string)` | <pre>{<br/>  "ManagedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of ECR repositories to create | <pre>map(object({<br/>    image_tag_mutability = string<br/>    scan_on_push         = bool<br/>    encryption_type      = string<br/>    lifecycle_policy     = string<br/>    force_delete         = optional(bool, false)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_arns"></a> [repository\_arns](#output\_repository\_arns) | Map of repository names to their ARNs |
| <a name="output_repository_registry_ids"></a> [repository\_registry\_ids](#output\_repository\_registry\_ids) | Map of repository names to their registry IDs |
| <a name="output_repository_urls"></a> [repository\_urls](#output\_repository\_urls) | Map of repository names to their repository URLs |
