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

variable "execution_role_name" {
  description = "Name of the shared ECS task execution role (used by all services)"
  type        = string
  default     = "ecs-task-execution-role"
}

variable "services" {
  description = "Map of ECS services to create"
  type = map(object({
    service_name                     = string
    desired_count                    = number
    task_family                      = string
    task_cpu                         = number
    task_memory                      = number
    container_name                   = string
    container_image                  = string
    container_port                   = number
    assign_public_ip                 = bool
    cloudwatch_log_group             = string
    security_group_name              = string
    target_group_arn                 = optional(string, null)
    autoscaling_enabled              = optional(bool, true)
    autoscaling_min_capacity         = optional(number, 1)
    autoscaling_max_capacity         = optional(number, 4)
    autoscaling_scale_up_threshold   = optional(number, 60)
    autoscaling_scale_down_threshold = optional(number, 55)
  }))
  default = {}
}

variable "capacity_provider" {
  description = "Capacity provider strategy for the service"
  type        = string
  default     = "FARGATE"
}

variable "capacity_provider_base" {
  description = "Base capacity provider strategy"
  type        = number
  default     = 1
}

variable "capacity_provider_weight" {
  description = "Weight for capacity provider strategy"
  type        = number
  default     = 100
}

variable "cloudwatch_log_stream_prefix" {
  description = "Prefix for CloudWatch log streams"
  type        = string
  default     = "ecs"
}

variable "autoscaling_scale_up_evaluation_periods" {
  description = "Number of evaluation periods for scale up alarm"
  type        = number
  default     = 2
}

variable "autoscaling_scale_down_evaluation_periods" {
  description = "Number of evaluation periods for scale down alarm"
  type        = number
  default     = 3
}

variable "autoscaling_metric_period" {
  description = "Period in seconds for metric evaluation"
  type        = number
  default     = 30
}

variable "autoscaling_cooldown" {
  description = "Cooldown period in seconds between scaling actions"
  type        = number
  default     = 60
}

variable "autoscaling_scale_up_adjustment" {
  description = "Number of tasks to add when scaling up"
  type        = number
  default     = 1
}

variable "autoscaling_scale_down_adjustment" {
  description = "Number of tasks to remove when scaling down"
  type        = number
  default     = -1
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
