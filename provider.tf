terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.33.0" # Terraform AWS provider version
    }
  }



  backend "s3" {
    bucket       = "venkatesh-remote"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

}

provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}
