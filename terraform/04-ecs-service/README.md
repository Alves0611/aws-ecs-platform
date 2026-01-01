## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.27.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |


## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_metric_alarm.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [terraform_remote_state.alb](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.ecs_cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_cooldown"></a> [autoscaling\_cooldown](#input\_autoscaling\_cooldown) | Cooldown period in seconds between scaling actions | `number` | `60` | no |
| <a name="input_autoscaling_metric_period"></a> [autoscaling\_metric\_period](#input\_autoscaling\_metric\_period) | Period in seconds for metric evaluation | `number` | `30` | no |
| <a name="input_autoscaling_scale_down_adjustment"></a> [autoscaling\_scale\_down\_adjustment](#input\_autoscaling\_scale\_down\_adjustment) | Number of tasks to remove when scaling down | `number` | `-1` | no |
| <a name="input_autoscaling_scale_down_evaluation_periods"></a> [autoscaling\_scale\_down\_evaluation\_periods](#input\_autoscaling\_scale\_down\_evaluation\_periods) | Number of evaluation periods for scale down alarm | `number` | `3` | no |
| <a name="input_autoscaling_scale_up_adjustment"></a> [autoscaling\_scale\_up\_adjustment](#input\_autoscaling\_scale\_up\_adjustment) | Number of tasks to add when scaling up | `number` | `1` | no |
| <a name="input_autoscaling_scale_up_evaluation_periods"></a> [autoscaling\_scale\_up\_evaluation\_periods](#input\_autoscaling\_scale\_up\_evaluation\_periods) | Number of evaluation periods for scale up alarm | `number` | `2` | no |
| <a name="input_capacity_provider"></a> [capacity\_provider](#input\_capacity\_provider) | Capacity provider strategy for the service | `string` | `"FARGATE"` | no |
| <a name="input_capacity_provider_base"></a> [capacity\_provider\_base](#input\_capacity\_provider\_base) | Base capacity provider strategy | `number` | `1` | no |
| <a name="input_capacity_provider_weight"></a> [capacity\_provider\_weight](#input\_capacity\_provider\_weight) | Weight for capacity provider strategy | `number` | `100` | no |
| <a name="input_cloudwatch_log_stream_prefix"></a> [cloudwatch\_log\_stream\_prefix](#input\_cloudwatch\_log\_stream\_prefix) | Prefix for CloudWatch log streams | `string` | `"ecs"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to all resources | `map(string)` | <pre>{<br/>  "ManagedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | Name of the shared ECS task execution role (used by all services) | `string` | `"ecs-task-execution-role"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_services"></a> [services](#input\_services) | Map of ECS services to create | <pre>map(object({<br/>    service_name                     = string<br/>    desired_count                    = number<br/>    task_family                      = string<br/>    task_cpu                         = number<br/>    task_memory                      = number<br/>    container_name                   = string<br/>    container_image                  = string<br/>    container_port                   = number<br/>    assign_public_ip                 = bool<br/>    cloudwatch_log_group             = string<br/>    security_group_name              = string<br/>    target_group_arn                 = optional(string, null)<br/>    autoscaling_enabled              = optional(bool, true)<br/>    autoscaling_min_capacity         = optional(number, 1)<br/>    autoscaling_max_capacity         = optional(number, 4)<br/>    autoscaling_scale_up_threshold   = optional(number, 60)<br/>    autoscaling_scale_down_threshold = optional(number, 55)<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"studying"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | ARN of the shared ECS task execution role |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | Map of service names to their security group IDs |
| <a name="output_services"></a> [services](#output\_services) | Map of service names to their service names |
| <a name="output_task_definitions"></a> [task\_definitions](#output\_task\_definitions) | Map of service names to their task definition ARNs |
