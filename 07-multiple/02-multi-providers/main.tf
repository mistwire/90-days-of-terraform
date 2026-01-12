# Random string for bucket name uniqueness
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# ====================================================================
# MULTI-REGION S3 BUCKETS using Provider Aliases
# ====================================================================
# The "provider" meta-argument specifies which provider configuration to use
# This allows you to deploy the same resource type to different regions

# S3 Bucket in PRIMARY region
# The provider meta-argument explicitly selects the "primary" alias configuration
resource "aws_s3_bucket" "primary" {
  provider = aws.primary # Uses the primary provider (us-east-1)
  bucket   = "primary-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "Primary Region Bucket"
    Environment = var.environment
    Region      = var.primary_region
  }
}

# S3 Bucket in SECONDARY region
# Same resource type, different provider = different AWS region
resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary # Uses the secondary provider (us-west-2)
  bucket   = "secondary-${var.environment}-${random_string.suffix.result}"

  tags = {
    Name        = "Secondary Region Bucket"
    Environment = var.environment
    Region      = var.secondary_region
  }
}

# ====================================================================
# MULTI-REGION SNS TOPICS using Provider Aliases
# ====================================================================
# This demonstrates deploying messaging infrastructure across regions
# Useful for disaster recovery, geographic distribution, etc.

# SNS Topic in PRIMARY region
resource "aws_sns_topic" "primary" {
  provider = aws.primary # Deployed to primary region
  name     = "primary-${var.environment}-topic"

  tags = {
    Name        = "Primary Region Topic"
    Environment = var.environment
    Region      = var.primary_region
  }
}

# SNS Topic in SECONDARY region
resource "aws_sns_topic" "secondary" {
  provider = aws.secondary # Deployed to secondary region
  name     = "secondary-${var.environment}-topic"

  tags = {
    Name        = "Secondary Region Topic"
    Environment = var.environment
    Region      = var.secondary_region
  }
}

# KEY CONCEPT: Each resource explicitly declares which provider to use
# Without the provider argument, Terraform would use the default (non-aliased) provider
# With multiple aliased providers and no default, you MUST specify provider for each resource