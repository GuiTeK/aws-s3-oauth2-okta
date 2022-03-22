terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18"

      configuration_aliases = [aws, aws.website-bucket]
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 1.1.0"
}
