# Random string for uniqueness
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# ====================================================================
# BASELINE RESOURCES - No lifecycle customizations
# ====================================================================
# These resources use default Terraform lifecycle behavior
# Default behavior: create -> update in place -> destroy

# S3 Bucket without lifecycle configuration
# Default lifecycle: Terraform will destroy this bucket if it needs to be replaced
resource "aws_s3_bucket" "standard" {
  bucket = "standard-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "Standard Bucket"
    Environment = var.environment
  }
}

# DynamoDB Table without lifecycle configuration
# Default lifecycle: Terraform will destroy and recreate if needed
resource "aws_dynamodb_table" "standard" {
  name         = "standard-${var.environment}-${random_string.suffix.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  tags = {
    Name        = "Standard Table"
    Environment = var.environment
  }
}

# ====================================================================
# LIFECYCLE: prevent_destroy
# ====================================================================
# The prevent_destroy argument prevents Terraform from destroying a resource
# If you try to destroy this resource, Terraform will throw an error
# Useful for protecting critical resources like production databases or S3 buckets with data

# S3 Bucket with prevent_destroy
# This bucket CANNOT be destroyed via "terraform destroy" - Terraform will error out
resource "aws_s3_bucket" "protected" {
  bucket = "protected-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "Protected Bucket"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true  # Prevents accidental deletion
  }
}
# To destroy this resource, you must first remove prevent_destroy from the config

# ====================================================================
# LIFECYCLE: create_before_destroy
# ====================================================================
# The create_before_destroy argument changes the replacement order
# DEFAULT: destroy old -> create new (causes downtime)
# WITH create_before_destroy: create new -> destroy old (zero downtime)
# Useful for resources that must always exist (load balancers, DNS records, etc.)

# DynamoDB Table with create_before_destroy
# If this table needs replacement, Terraform will:
# 1. Create the new table first
# 2. Update references to point to the new table
# 3. Then destroy the old table
resource "aws_dynamodb_table" "replacement" {
  name         = "replacement-${var.environment}-${random_string.suffix.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  tags = {
    Name        = "Replacement Table"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true  # Ensures continuous availability during replacement
  }
}

# ====================================================================
# LIFECYCLE: ignore_changes
# ====================================================================
# The ignore_changes argument tells Terraform to ignore changes to specific attributes
# Useful when resources are modified outside Terraform (by other tools, manual changes, auto-scaling, etc.)
# Terraform will create the resource but won't try to revert external changes

# SNS Topic with ignore_changes
# The Version tag can be changed outside Terraform without triggering updates
resource "aws_sns_topic" "updates" {
  name = "updates-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "Updates Topic"
    Environment = var.environment
    Version     = "2.0.0"  # Even if changed to "3.0.0" externally, Terraform won't revert it
  }

  lifecycle {
    ignore_changes = [
      tags["Version"]  # Ignores changes to the Version tag only
    ]
    # You can also use ignore_changes = all to ignore all attribute changes
  }
}