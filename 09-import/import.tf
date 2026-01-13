# ====================================================================
# IMPORT BLOCKS - Declarative Resource Import (Terraform 1.5+)
# ====================================================================
# Import blocks provide a declarative way to import existing resources
# Unlike the old CLI method, import blocks are:
# - Version controlled (part of your Terraform code)
# - Repeatable (anyone can run terraform apply to import)
# - Declarative (describe what should be imported, not how)
# - Can be used with -generate-config-out to auto-generate configuration

# ====================================================================
# IMPORT BLOCK SYNTAX
# ====================================================================
# import {
#   to = resource_type.resource_name  # The Terraform resource address
#   id = "resource-id"                # The provider-specific resource ID
# }
#
# The "to" field specifies where to import the resource in your configuration
# The "id" field is the unique identifier from the cloud provider

# ====================================================================
# EXAMPLE 1: Import a VPC
# ====================================================================
# Scenario: A VPC was created manually (or by another tool) in AWS
# We want to bring it under Terraform management
#
# Steps to find the VPC ID:
# 1. AWS Console: VPC Dashboard -> Your VPCs -> Copy the VPC ID
# 2. AWS CLI: aws ec2 describe-vpcs --filters "Name=tag:Name,Values=import-example-vpc"
# 3. The VPC ID format is: vpc-xxxxxxxxxxxxxxxxx

# UNCOMMENT BELOW TO IMPORT AN EXISTING VPC
# Replace "vpc-12345678" with your actual VPC ID
#
# import {
#   to = aws_vpc.imported_vpc
#   id = "vpc-12345678"  # Replace with actual VPC ID
# }
#
# # You MUST also define the resource configuration to match the existing VPC
# resource "aws_vpc" "imported_vpc" {
#   cidr_block           = "10.0.0.0/16"  # Must match the existing VPC
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#
#   tags = {
#     Name        = "imported-vpc"
#     Environment = var.environment
#     ManagedBy   = "Terraform"
#   }
# }

# ====================================================================
# EXAMPLE 2: Import an S3 Bucket
# ====================================================================
# S3 bucket IDs are simply the bucket name

# UNCOMMENT TO IMPORT AN EXISTING S3 BUCKET
#
# import {
#   to = aws_s3_bucket.imported_bucket
#   id = "my-existing-bucket-name"  # Replace with actual bucket name
# }
#
# resource "aws_s3_bucket" "imported_bucket" {
#   bucket = "my-existing-bucket-name"  # Must match the id above
#
#   tags = {
#     Name        = "Imported Bucket"
#     Environment = var.environment
#   }
# }

# ====================================================================
# EXAMPLE 3: Import Multiple Resources with for_each
# ====================================================================
# You can use for_each with import blocks to import multiple resources

# UNCOMMENT TO IMPORT MULTIPLE S3 BUCKETS
#
# locals {
#   existing_buckets = {
#     logs = "my-logs-bucket"
#     data = "my-data-bucket"
#     backup = "my-backup-bucket"
#   }
# }
#
# import {
#   for_each = local.existing_buckets
#   to       = aws_s3_bucket.imported_buckets[each.key]
#   id       = each.value
# }
#
# resource "aws_s3_bucket" "imported_buckets" {
#   for_each = local.existing_buckets
#   bucket   = each.value
#
#   tags = {
#     Name    = each.key
#     Purpose = "Imported via Terraform"
#   }
# }

# ====================================================================
# USING -generate-config-out FLAG
# ====================================================================
# The -generate-config-out flag automatically generates resource configuration
# This eliminates the manual work of writing resource blocks
#
# WORKFLOW WITH AUTO-GENERATION:
#
# 1. Create ONLY the import block (no resource block needed yet):
#
#    import {
#      to = aws_vpc.auto_imported
#      id = "vpc-12345678"
#    }
#
# 2. Run terraform plan with -generate-config-out:
#
#    terraform plan -generate-config-out=generated.tf
#
# 3. Terraform will:
#    - Read the existing resource from AWS
#    - Generate a resource block with all current attributes
#    - Write it to generated.tf
#
# 4. Review generated.tf and adjust as needed:
#    - Remove computed/read-only attributes
#    - Add lifecycle rules if needed
#    - Update tags or other values
#    - Move to a different file if desired
#
# 5. Run terraform plan again to verify the configuration matches
#
# 6. Run terraform apply to complete the import
#
# 7. Remove the import block (no longer needed)
#
# EXAMPLE COMMAND:
# terraform plan -generate-config-out=generated_resources.tf

# ====================================================================
# FINDING RESOURCE IDs
# ====================================================================
# Each AWS resource type has a different ID format. Here are common examples:
#
# VPC:              vpc-xxxxxxxxxxxxxxxxx
# Subnet:           subnet-xxxxxxxxxxxxxxxxx
# Security Group:   sg-xxxxxxxxxxxxxxxxx
# EC2 Instance:     i-xxxxxxxxxxxxxxxxx
# S3 Bucket:        bucket-name (just the name)
# DynamoDB Table:   table-name (just the name)
# IAM Role:         role-name (just the name)
# Lambda Function:  function-name (just the name)
# RDS Instance:     database-identifier
# ELB:              load-balancer-name
# Route53 Zone:     Z1234567890ABC (hosted zone ID)
#
# Check the Terraform provider documentation for the exact ID format
# for each resource type: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# ====================================================================
# BEST PRACTICES FOR IMPORT
# ====================================================================
# 1. Always use import blocks (Terraform 1.5+) instead of CLI import
# 2. Use -generate-config-out to automatically generate configuration
# 3. Review generated configuration for sensitive data before committing
# 4. Import resources incrementally, not all at once
# 5. Test imports in a non-production environment first
# 6. Document which resources were imported and why (in comments or docs)
# 7. Remove import blocks after successful import to keep code clean
# 8. Use version control to track import blocks before removing them

# ====================================================================
# TROUBLESHOOTING IMPORT
# ====================================================================
# Error: "resource already managed by Terraform"
# - The resource is already in state, no need to import
# - Check: terraform state list
#
# Error: "resource does not exist"
# - Double check the resource ID
# - Verify you're in the correct AWS region/account
#
# Error: "configuration mismatch after import"
# - Your resource configuration doesn't match the actual resource
# - Use -generate-config-out to get the correct configuration
# - Run terraform plan to see the differences
#
# Error: "sensitive values not available"
# - Some values (passwords, private keys) cannot be imported for security
# - You must set these values manually in your configuration
# - Use lifecycle { ignore_changes = [...] } if needed
