# Data Source: AWS Region
# Retrieves information about the current AWS region being used
# This is used in locals and tags to dynamically reference the region
data "aws_region" "current" {}

# Locals Block
# Defines local values (like variables, but computed within the module)
# Locals are useful for:
# 1. DRY principle - Define once, use many times (reducing repetition)
# 2. Composing values from multiple sources (vars, data sources, resources)
# 3. Making complex expressions readable by giving them meaningful names
#
# Syntax: Access locals with "local.<name>" (singular "local", not "locals")
# Unlike variables, locals can reference other resources, data sources, and even other locals
locals {
  # Common tags map - a reusable set of tags for ALL resources
  # Instead of repeating these 6 tags in every resource, we define them once here
  # This ensures consistency and makes updates easier (change once, applies everywhere)
  tags = {
    Environment = var.environment
    Project     = "terraform-improved-demo"
    Owner       = "devops-team"
    CostCenter  = "cc-5678"
    # Locals can reference data sources - this dynamically gets the current region
    Region    = data.aws_region.current.region
    ManagedBy = "terraform"
    Lab       = "lab-07"
  }

  # Computed naming prefix for consistent resource naming
  # This combines the environment variable with a literal string
  # Example result: "dev-tf-" or "prod-tf-"
  # Using a local for this means all resources use the same naming pattern
  name_prefix = "${var.environment}-tf-"
}


# Resource: AWS VPC (Virtual Private Cloud)
# Creates an isolated virtual network in AWS for your resources
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Demonstrating local value references with "local.<name>" syntax
  # We're manually extracting each tag from local.tags and adding a custom Name tag
  # Notice how we reference individual map keys: local.tags.Environment, local.tags.Project, etc.
  # This approach works but is verbose - compare with the merge() approach in public_a subnet below
  tags = {
    # Combining local.name_prefix with other values for a descriptive resource name
    # This creates something like: "dev-tf-vpc-us-east-1"
    Name = "${local.name_prefix}vpc-${data.aws_region.current.region}"
    # Accessing individual values from the local.tags map
    # Format: local.<local_name>.<map_key>
    Environment = local.tags.Environment
    Project     = local.tags.Project
    Owner       = local.tags.Owner
    CostCenter  = local.tags.CostCenter
    Region      = local.tags.Region
    ManagedBy   = local.tags.ManagedBy
  }
}

# Resource: AWS Subnet (Public Subnet in AZ A)
# Subnets divide your VPC into smaller network segments
# Public subnets have routes to the internet via an Internet Gateway
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  # Hardcoding availability zone for explicit control
  # In production, you might use data sources to make this dynamic
  availability_zone = "us-east-1a"
  # map_public_ip_on_launch = true makes this a "public" subnet
  # Instances launched here will automatically get public IP addresses
  map_public_ip_on_launch = true

  # merge() Function - A Better Way to Handle Tags
  # Syntax: merge(map1, map2, ...) combines multiple maps into one
  # How it works:
  # 1. Takes all key-value pairs from the first map (local.tags)
  # 2. Adds/overwrites with key-value pairs from subsequent maps
  # 3. If keys conflict, later maps override earlier ones
  #
  # Example with our values:
  #   local.tags provides: {Environment, Project, Owner, CostCenter, Region, ManagedBy}
  #   Second map adds: {Name, Tier}
  #   Result: All 8 tags combined into one map
  #
  # This is much cleaner than listing all tags manually (see VPC above for comparison)
  # Benefits: Less typing, easier maintenance, consistent base tags across resources
  tags = merge(local.tags, {
    Name = "${local.name_prefix}public-subnet-us-east-1a"
    Tier = "public"
  })
}

# Resource: AWS Subnet (Public Subnet in AZ B)
# Second public subnet in a different availability zone for high availability
# Notice this uses manual tag listing instead of merge() - both approaches work
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  # Manual tag listing approach (compare with merge() in public_a above)
  # This works fine but requires more typing and is harder to maintain
  tags = {
    Name        = "${local.name_prefix}public-subnet-us-east-1b"
    Environment = local.tags.Environment
    Project     = local.tags.Project
    Owner       = local.tags.Owner
    CostCenter  = local.tags.CostCenter
    Region      = local.tags.Region
    ManagedBy   = local.tags.ManagedBy
    Tier        = "public"
  }
}

# Resource: AWS Subnet (Private Subnet in AZ A)
# Private subnets don't have direct internet access (map_public_ip_on_launch = false)
# Typically used for databases, internal services, and backend applications
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  # false = private subnet, instances won't get public IPs automatically
  map_public_ip_on_launch = false

  tags = {
    Name        = "${local.name_prefix}private-subnet-us-east-1a"
    Environment = local.tags.Environment
    Project     = local.tags.Project
    Owner       = local.tags.Owner
    CostCenter  = local.tags.CostCenter
    Region      = local.tags.Region
    ManagedBy   = local.tags.ManagedBy
    Tier        = "private"
  }
}

# Resource: AWS Subnet (Private Subnet in AZ B)
# Second private subnet for high availability of backend resources
resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${local.name_prefix}private-subnet-us-east-1b"
    Environment = local.tags.Environment
    Project     = local.tags.Project
    Owner       = local.tags.Owner
    CostCenter  = local.tags.CostCenter
    Region      = local.tags.Region
    ManagedBy   = local.tags.ManagedBy
    Tier        = "private"
  }
}

# Resource: AWS Security Group
# Security groups act as virtual firewalls that control inbound and outbound traffic
# They operate at the instance level (not subnet level like NACLs)
# Key concepts:
# - Stateful: if you allow inbound traffic, the response is automatically allowed out
# - Default deny: all traffic is blocked unless explicitly allowed
# - Rules specify: protocol, port range, and source/destination
resource "aws_security_group" "web" {
  name        = "${local.name_prefix}web-sg"
  description = "Allow web traffic"
  # Security groups must be associated with a VPC
  vpc_id = aws_vpc.main.id

  # Ingress Block: Defines INBOUND traffic rules (traffic coming TO your resources)
  # This rule allows HTTP traffic from anywhere on the internet
  ingress {
    from_port = 80    # Starting port in the range
    to_port   = 80    # Ending port in the range (same = single port)
    protocol  = "tcp" # Protocol: tcp, udp, icmp, or -1 for all
    # CIDR blocks that are allowed to connect
    # 0.0.0.0/0 means "anywhere on the internet" (all IPv4 addresses)
    # In production, you might restrict this to specific IPs or ranges
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Second ingress rule for HTTPS traffic (port 443)
  # You can have multiple ingress blocks for different ports/protocols
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress Block: Defines OUTBOUND traffic rules (traffic going FROM your resources)
  # This rule allows all outbound traffic to anywhere
  egress {
    from_port = 0 # 0 means all ports
    to_port   = 0 # 0 means all ports
    # protocol = "-1" means ALL protocols (TCP, UDP, ICMP, etc.)
    # This is equivalent to "any" or "all"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound to anywhere
  }

  # Using manual tag listing here - could also use merge() like in public_a subnet
  tags = {
    Name        = "${local.name_prefix}web-sg"
    Environment = local.tags.Environment
    Project     = local.tags.Project
    Owner       = local.tags.Owner
    CostCenter  = local.tags.CostCenter
    Region      = local.tags.Region
    ManagedBy   = local.tags.ManagedBy
  }
}
