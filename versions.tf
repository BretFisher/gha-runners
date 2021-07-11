terraform {
  required_providers {
    aws = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest
      source  = "hashicorp/aws"
      version = "~> 3.49.0"
    }
  }
  required_version = ">= 1.0.0"
}