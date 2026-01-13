# ====================================================================
# TERRAFORM IMPORT - Bringing Existing Resources Under Terraform Management
# ====================================================================
# The import feature allows you to bring existing infrastructure into Terraform
# This is useful when:
# - You have manually created resources that you want to manage with Terraform
# - You're migrating from another IaC tool to Terraform
# - You need to manage resources created by other teams or tools
# - You want to recover from lost state files
#
# IMPORTANT: Import does NOT generate configuration automatically by default
# You must write the resource configuration yourself to match the existing resource
# However, Terraform 1.5+ introduced -generate-config-out to help with this

# ====================================================================
# STEP 1: Create Resources to Import (Simulating Existing Infrastructure)
# ====================================================================
# In a real scenario, these resources would already exist in AWS
# We're creating them here to demonstrate the import process

# Example VPC that will be "manually created" then imported
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "import-example-vpc"
    Environment = var.environment
    ManagedBy   = "Manual" # Will change to "Terraform" after import
  }
}

# Example S3 bucket that will be imported
resource "aws_s3_bucket" "example" {
  bucket = "${var.environment}-import-example-bucket-${random_string.suffix.result}"

  tags = {
    Name        = "Import Example Bucket"
    Environment = var.environment
    Purpose     = "Demonstrating Terraform import"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Example DynamoDB table that will be imported
resource "aws_dynamodb_table" "example" {
  name         = "${var.environment}-import-example-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "Import Example Table"
    Environment = var.environment
  }
}

# ====================================================================
# TRADITIONAL IMPORT METHOD (Before Terraform 1.5)
# ====================================================================
# The old way to import resources was using the CLI command:
#
# terraform import aws_vpc.imported_vpc vpc-12345678
#
# Problems with this approach:
# 1. Imperative (must run manually for each resource)
# 2. Not repeatable (not in code)
# 3. Doesn't generate configuration (you must write it yourself)
# 4. Easy to make mistakes or forget to import resources
# 5. No version control of the import process
#
# This method still works but is not recommended for new projects

# ====================================================================
# MODERN IMPORT METHOD (Terraform 1.5+): Import Blocks
# ====================================================================
# See import.tf for examples of the modern declarative import approach
# Import blocks are:
# - Declarative (defined in code, not CLI commands)
# - Repeatable (anyone can run terraform plan to import)
# - Version controlled (the import logic is in your repo)
# - Can generate configuration automatically with -generate-config-out

# ====================================================================
# WORKFLOW FOR IMPORTING RESOURCES
# ====================================================================
# 1. Identify the resource you want to import (e.g., VPC ID: vpc-12345678)
#
# 2. Find the resource type in Terraform docs (e.g., aws_vpc)
#
# 3. Create an import block (see import.tf):
#    import {
#      to = aws_vpc.imported
#      id = "vpc-12345678"
#    }
#
# 4. EITHER write the resource configuration manually:
#    resource "aws_vpc" "imported" {
#      cidr_block = "10.0.0.0/16"
#      # ... match existing resource attributes
#    }
#
# 5. OR use -generate-config-out to generate it automatically:
#    terraform plan -generate-config-out=generated.tf
#    This creates generated.tf with the resource configuration
#
# 6. Run terraform plan to see if configuration matches
#    If there are differences, update your configuration
#
# 7. Run terraform apply to complete the import
#    The resource is now in the Terraform state
#
# 8. Remove the import block (it's only needed once)
#    The resource is now managed by Terraform

# ====================================================================
# IMPORTANT NOTES ABOUT IMPORT
# ====================================================================
# - Import ONLY brings resources into state, it doesn't create them
# - You must ensure your configuration matches the existing resource
# - Some attributes may not be importable (check provider docs)
# - Sensitive values (passwords, keys) are not imported for security
# - After import, the resource is managed by Terraform like any other
# - If you destroy the imported resource, Terraform will delete it!
# - Import blocks can be removed after successful import
