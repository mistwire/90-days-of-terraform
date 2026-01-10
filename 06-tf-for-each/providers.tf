# Terraform Block
# Specifies the required Terraform version and provider versions
terraform {
  required_version = ">= 1.10.0"  # Terraform CLI version must be 1.10.0 or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Official AWS provider from HashiCorp
      version = "~> 6.0"  # Allows 6.x versions (pessimistic constraint)
    }
  }
}

# AWS Provider Configuration
# Configures the AWS provider with the region to deploy resources
provider "aws" {
  region = "us-east-1"  # US East (N. Virginia) region
  # In production, credentials are typically set via environment variables:
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
}