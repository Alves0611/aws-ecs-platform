provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "root_account"
  region = var.region
}