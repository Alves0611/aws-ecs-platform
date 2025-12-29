data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"

  config = {
    bucket         = "tfstate-444065722670"
    key            = "ecs/ecs-cluster/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-locking-444065722670"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket         = "tfstate-444065722670"
    key            = "ecs/alb/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-locking-444065722670"
  }
}

