# ====================================================================
# PUBLIC MODULES from Terraform Registry
# ====================================================================
# Modules allow you to package and reuse Terraform configurations
# Public modules are shared via the Terraform Registry (registry.terraform.io)
#
# Module syntax:
# - source: where to find the module (registry, git, local path)
# - version: specific version to use (highly recommended for stability)
# - other arguments: inputs to configure the module (defined in module's variables.tf)
#
# The source format for registry modules: "namespace/name/provider"
# Example: "terraform-aws-modules/vpc/aws" means:
#   - namespace: terraform-aws-modules (GitHub organization)
#   - name: vpc (module name)
#   - provider: aws (for AWS)

# Module 1: VPC Module from Terraform Registry
# This module creates a complete VPC with subnets, route tables, and gateways
# Module outputs can be referenced as: module.vpc.output_name
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" # Public module from registry
  version = "6.6.0"                         # Pin to specific version for reproducibility

  # Module inputs - these are variables defined in the module's variables.tf
  name = "${var.environment}-${var.vpc_name}"
  cidr = var.vpc_cidr

  # Availability zones and subnet configuration
  azs             = ["${var.region}a", "${var.region}b"] # List of AZs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]       # Private subnet CIDRs
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]   # Public subnet CIDRs

  # NAT and VPN gateway settings
  enable_nat_gateway = false # NAT gateway allows private subnets to reach internet
  enable_vpn_gateway = false # VPN gateway for site-to-site VPN connections

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

# ====================================================================
# MODULE OUTPUTS and MODULE DEPENDENCIES
# ====================================================================
# Module outputs are accessed using: module.<module_name>.<output_name>
# This creates an IMPLICIT DEPENDENCY between resources/modules

# Module 2: Security Group Module from Terraform Registry
# Demonstrates using module outputs to create dependencies between modules
module "security_group_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.environment}-web-sg"
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id # Using output from the VPC module (creates dependency)

  # Predefined rule names from the module (abstracts port/protocol details)
  ingress_cidr_blocks = ["0.0.0.0/0"]                    # Allow from anywhere
  ingress_rules       = ["http-80-tcp", "https-443-tcp"] # Predefined rules
  egress_rules        = ["all-all"]                      # Allow all outbound

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Role        = "web"
  }
}

# ====================================================================
# REUSING MODULES - Multiple Instances
# ====================================================================
# You can call the same module multiple times with different inputs
# Each module call creates a separate set of resources

# Calling the Security Group module a SECOND time to create a different security group
# This demonstrates module reusability - same code, different configuration
module "security_group_app" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.environment}-app-sg"
  description = "Security group for application servers"
  vpc_id      = module.vpc.vpc_id # Using output from the VPC module

  # Different configuration than the web security group
  ingress_cidr_blocks = [var.vpc_cidr] # Only allow traffic from within the VPC
  ingress_rules       = ["ssh-tcp"]    # Predefined SSH rule

  # Custom rule using ingress_with_cidr_blocks for non-standard ports
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Application port"
      cidr_blocks = var.vpc_cidr
    }
  ]
  egress_rules = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Role        = "app"
  }
}

# Random string for uniqueness
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# ====================================================================
# MODULES with for_each
# ====================================================================
# You can use for_each with modules to create multiple module instances
# This is powerful for creating similar resources with different configurations

# Module 3: Using S3 bucket module with for_each
# Creates multiple S3 buckets from a map variable
# Each bucket gets created from the same module but with different names/purposes
module "s3_buckets" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.10.0"

  # for_each creates one module instance per map entry
  # Access keys with each.key and values with each.value
  for_each = var.s3_buckets # e.g., {"logs" = "Log storage", "data" = "Data storage"}

  # each.key is the bucket name (e.g., "logs", "data")
  bucket = "${var.environment}-${each.key}-bucket-${random_string.suffix.result}"

  # S3 bucket-level Public Access Block configuration
  # These settings prevent public access to the bucket
  block_public_acls       = true # Block public ACLs
  block_public_policy     = true # Block public bucket policies
  ignore_public_acls      = true # Ignore public ACLs
  restrict_public_buckets = true # Restrict public bucket policies

  # Versioning configuration (object is expected by the module)
  versioning = {
    enabled = false # Disable versioning to save costs
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Purpose     = each.value # each.value is the description from the map
    Name        = "${var.environment}-${each.key}-bucket"
  }
}

# ACCESSING for_each MODULE OUTPUTS:
# When using for_each with modules, outputs become maps:
# - module.s3_buckets["logs"].s3_bucket_id
# - module.s3_buckets["data"].s3_bucket_arn
# Without for_each, outputs are accessed directly:
# - module.vpc.vpc_id
