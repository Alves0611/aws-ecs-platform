execution_role_name = "ecs-task-execution-role"

services = {
  "python-api" = {
    service_name                     = "python-api-service"
    desired_count                    = 1
    task_family                      = "task-python-api"
    task_cpu                         = 512
    task_memory                      = 1024
    container_name                   = "python-api"
    container_image                  = "444065722670.dkr.ecr.us-east-1.amazonaws.com/python-api:latest"
    container_port                   = 8000
    assign_public_ip                 = false
    cloudwatch_log_group             = "/aws/studying-cluster/python-api/log-group"
    security_group_name              = "ecs-python-api-sg"
    target_group_arn                 = null
    autoscaling_enabled              = true
    autoscaling_min_capacity         = 1
    autoscaling_max_capacity         = 4
    autoscaling_scale_up_threshold   = 60
    autoscaling_scale_down_threshold = 55
  }
  "react" = {
    service_name                     = "react-service"
    desired_count                    = 1
    task_family                      = "task-react"
    task_cpu                         = 512
    task_memory                      = 1024
    container_name                   = "react"
    container_image                  = "444065722670.dkr.ecr.us-east-1.amazonaws.com/react:latest"
    container_port                   = 80
    assign_public_ip                 = false
    cloudwatch_log_group             = "/aws/studying-cluster/react/log-group"
    security_group_name              = "ecs-react-sg"
    target_group_arn                 = null
    autoscaling_enabled              = true
    autoscaling_min_capacity         = 1
    autoscaling_max_capacity         = 2
    autoscaling_scale_up_threshold   = 60
    autoscaling_scale_down_threshold = 55
  }
}

common_tags = {
  ManagedBy = "Terraform"
  Project   = "aws-ecs-platform"
}

