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

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "python-api-service"
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
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

variable "task_family" {
  description = "Family name for the task definition"
  type        = string
  default     = "task-python-api"
}

variable "task_cpu" {
  description = "CPU units for the task (1024 = 1 vCPU)"
  type        = number
  default     = 1024
}

variable "task_memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 2048
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "python-api"
}

variable "container_image" {
  description = "Container image URI"
  type        = string
  default     = "444065722670.dkr.ecr.us-east-1.amazonaws.com/python-api"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "assign_public_ip" {
  description = "Whether to assign public IP to tasks"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group" {
  description = "CloudWatch log group name"
  type        = string
  default     = "/aws/studying-cluster/python-api/log-group"
}

variable "cloudwatch_log_stream_prefix" {
  description = "Prefix for CloudWatch log streams"
  type        = string
  default     = "ecs"
}

variable "execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
  default     = "studying-ecs-execution-role"
}

variable "security_group_name" {
  description = "Name of the security group for ECS tasks"
  type        = string
  default     = "ecs-tasks-python-api-sg"
}

variable "security_group_description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for ECS tasks to allow traffic from ALB"
}

variable "security_group_port" {
  description = "Port to allow traffic from ALB"
  type        = number
  default     = 8000
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
