terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
  backend "s3" {
    bucket         = "tfstate-444065722670"
    key            = "ecs/github-oidc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-locking-444065722670"
  }
}


