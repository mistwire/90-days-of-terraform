# Data Source: AWS Caller Identity
# Fetches information about the AWS account currently in use
# This is used to get the ARN of the current user for the S3 bucket policy
data "aws_caller_identity" "current" {}

# Random String for Unique S3 Bucket Name
# S3 bucket names must be globally unique across all AWS accounts
# This generates a random 8-character suffix to append to the bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false # No special characters (!@#$, etc.)
  upper   = false # Only lowercase letters
}

# VPC - Virtual Private Cloud
# This resource demonstrates IMPLICIT dependency - other resources reference aws_vpc.main.id
# Terraform automatically knows these resources depend on the VPC being created first
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "main-vpc"
    Environment = var.environment
  }
}

# Subnet within the VPC
# IMPLICIT dependency: references aws_vpc.main.id, so Terraform waits for VPC creation
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id # Creates implicit dependency on aws_vpc.main
  cidr_block        = var.subnet_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name        = "public-subnet"
    Environment = var.environment
  }
}

# Internet Gateway
# IMPLICIT dependency: references aws_vpc.main.id
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id # Creates implicit dependency on aws_vpc.main

  tags = {
    Name        = "main-igw"
    Environment = var.environment
  }
}

# Route Table with Default Route to Internet
# IMPLICIT dependency: references both aws_vpc.main.id and aws_internet_gateway.igw.id
# Terraform automatically creates the dependency graph: VPC -> IGW -> Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id # Implicit dependency on VPC

  route {
    cidr_block = "0.0.0.0/0"                 # Route all traffic
    gateway_id = aws_internet_gateway.igw.id # Implicit dependency on IGW
  }

  tags = {
    Name        = "public-route-table"
    Environment = var.environment
  }
}

# S3 Bucket for Application Logs
# IMPLICIT dependency: references random_string.suffix.result
resource "aws_s3_bucket" "logs" {
  bucket = "logs-${random_string.suffix.result}" # Implicit dependency on random_string

  tags = {
    Name        = "logs-bucket"
    Environment = var.environment
  }
}

# Route Table Association
# Associates the route table with the subnet to enable routing
# IMPLICIT dependency: references both subnet and route table IDs
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id      # Implicit dependency on subnet
  route_table_id = aws_route_table.public.id # Implicit dependency on route table
}

# Security Group for Web Servers
# IMPLICIT dependency: references aws_vpc.main.id
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id # Implicit dependency on VPC

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound to anywhere
  }

  tags = {
    Name        = "web-sg"
    Environment = var.environment
  }
}

# S3 Bucket Policy - Defines Access Permissions
# IMPLICIT dependencies: references aws_s3_bucket.logs and data.aws_caller_identity.current
# The jsonencode() function converts a Terraform object into a JSON string
resource "aws_s3_bucket_policy" "logs_policy" {
  bucket = aws_s3_bucket.logs.id # Implicit dependency on bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject" # Allow reading objects from the bucket
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.logs.arn,       # The bucket itself
          "${aws_s3_bucket.logs.arn}/*" # All objects within the bucket
        ]
        Principal = {
          AWS = "${data.aws_caller_identity.current.arn}" # Current AWS user/role
        }
      }
    ]
  })
}

# ====================================================================
# EXPLICIT DEPENDENCY EXAMPLE #1: depends_on Meta-Argument
# ====================================================================
# Security Group Rule with EXPLICIT dependency
# This demonstrates the depends_on meta-argument - a way to manually declare dependencies
# that Terraform cannot automatically infer from resource references
resource "aws_security_group_rule" "http" {
  type              = "ingress" # Inbound rule
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id # Implicit dependency on security group

  # EXPLICIT DEPENDENCY using depends_on
  # WHY? There's no direct reference to the route table association in this resource,
  # but we want to ensure network routing is fully configured before opening ports.
  # Without depends_on, Terraform might create this rule before routing is ready.
  # depends_on takes a LIST of resources (note the square brackets)
  depends_on = [aws_route_table_association.public]
}

# ====================================================================
# EXPLICIT DEPENDENCY EXAMPLE #2: Chained Dependencies
# ====================================================================
# S3 Bucket Versioning with EXPLICIT dependency
# Even though we reference the bucket ID (implicit dependency on the bucket),
# we also want to ensure the bucket policy is applied BEFORE enabling versioning
resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.logs.id # Implicit dependency on bucket

  versioning_configuration {
    status = "Enabled" # Turn on versioning to keep object history
  }

  # EXPLICIT DEPENDENCY using depends_on
  # WHY? We want the bucket policy fully applied before enabling versioning.
  # This ensures proper access controls are in place first.
  depends_on = [aws_s3_bucket_policy.logs_policy]
}

# ====================================================================
# EXPLICIT DEPENDENCY EXAMPLE #3: Dependency Chains
# ====================================================================
# S3 Bucket Logging Configuration
# Enables logging of access to this bucket (stores logs in the same bucket under "log/" prefix)
resource "aws_s3_bucket_logging" "logs_logging" {
  bucket = aws_s3_bucket.logs.id # Implicit dependency on bucket

  target_bucket = aws_s3_bucket.logs.id # Store logs in the same bucket
  target_prefix = "log/"                # Prefix for log objects

  # EXPLICIT DEPENDENCY using depends_on
  # WHY? Creates a dependency chain: bucket -> policy -> versioning -> logging
  # Logging should be enabled only after versioning is configured.
  # This demonstrates how depends_on can create SEQUENTIAL operations.
  depends_on = [aws_s3_bucket_versioning.logs_versioning]
}

# DEPENDENCY CHAIN SUMMARY:
# 1. aws_s3_bucket.logs (created first)
# 2. aws_s3_bucket_policy.logs_policy (depends on bucket implicitly)
# 3. aws_s3_bucket_versioning.logs_versioning (depends on policy via depends_on)
# 4. aws_s3_bucket_logging.logs_logging (depends on versioning via depends_on)