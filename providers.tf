terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "P6P7-CE-ECS-Fargate-Observability"
      ManagedBy   = "Terraform"
      Environment = "Production"
    }
  }
}