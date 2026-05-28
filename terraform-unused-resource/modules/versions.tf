
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.33.0"
      # This tells the module to expect a provider named "aws" 
      # passed in from the parent module call.
      configuration_aliases = [aws]
    }
  }
}
