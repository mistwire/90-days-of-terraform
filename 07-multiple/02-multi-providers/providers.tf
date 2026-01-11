terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

# ====================================================================
# MULTIPLE PROVIDER CONFIGURATIONS
# ====================================================================
# You can configure the same provider multiple times with different settings
# Use the "alias" meta-argument to distinguish between provider configurations
# This is useful for multi-region deployments, multi-account setups, etc.

# Primary region provider configuration
# This is the "primary" alias - referenced as: provider = aws.primary
provider "aws" {
  region = var.primary_region  # e.g., us-east-1
  alias  = "primary"            # Unique identifier for this provider configuration
}

# Secondary region provider configuration
# This is the "secondary" alias - referenced as: provider = aws.secondary
provider "aws" {
  region = var.secondary_region  # e.g., us-west-2
  alias  = "secondary"            # Different alias for the second region
}

# USAGE: In resources, specify which provider to use:
# resource "aws_s3_bucket" "example" {
#   provider = aws.primary    # Uses the primary region
#   ...
# }