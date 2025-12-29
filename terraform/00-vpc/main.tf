module "vpc" {
  source = "git::https://github.com/Alves0611/study-modules.git//aws-vpc"
  name     = "studying"
  vpc_cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]

  enable_nat_gateway = true

  tags = {
    ManagedBy = "Terraform"
  }
}

