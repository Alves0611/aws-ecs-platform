variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-cluster"
}

variable "capacity_providers" {
  description = "List of capacity providers to associate with the cluster"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "default_capacity_provider_strategy" {
  description = "Configuration block for default capacity provider strategy"
  type = object({
    base              = number
    weight            = number
    capacity_provider = string
  })
  default = {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

variable "tags" {
  description = "A map of tags to assign to the cluster"
  type        = map(string)
  default     = {}
}

