# Data Source: AWS Availability Zones
# Retrieves a list of availability zones in the current region
# Data sources are read-only and don't create infrastructure - they fetch existing information
# This is useful for distributing resources across multiple AZs for high availability
data "aws_availability_zones" "available" {
  # Filter to only include AZs that are currently available for use
  # Some AZs might be restricted or unavailable in certain accounts
  state = "available"
}

# Data Source: AWS Region
# Retrieves information about the current AWS region
# This data source is empty {} because it automatically detects the region
# from your provider configuration (no filters needed)
# Useful for tagging resources with their region for better organization
data "aws_region" "current" {}

# Data Source: AWS Caller Identity
# Retrieves details about the AWS account and credentials being used
# This is helpful for tagging resources with account information
# and implementing multi-account deployment patterns
data "aws_caller_identity" "current" {}

# Resource: AWS VPC (Virtual Private Cloud)
# VPCs provide network isolation, security, and control over your cloud infrastructure
resource "aws_vpc" "production" {
  # CIDR block defines the IP address range for the entire VPC
  # All subnets within this VPC must use IP ranges that fit within this CIDR
  cidr_block = var.vpc_cidr

  # Enable DNS hostnames allows EC2 instances to receive public DNS hostnames
  # This is required if you want instances to be reachable via DNS names
  enable_dns_hostnames = true

  # Enable DNS support allows resources in the VPC to resolve DNS queries
  # via Amazon's Route 53 Resolver (enabled by default, but explicit is better)
  enable_dns_support = true

  # Tags are key-value pairs used for organization, billing, and automation
  # Best practice: use consistent tagging across all resources
  tags = {
    # String interpolation using ${} combines variables with literals
    # This creates a unique, descriptive name for the VPC
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    # Using data sources for dynamic tagging ensures accuracy
    # data.aws_region.current.name fetches the actual region name (e.g., "us-east-1")
    Region = data.aws_region.current.id
    # data.aws_caller_identity.current.account_id provides the 12-digit account ID
    AccountID = data.aws_caller_identity.current.account_id
  }
}

# Resource: AWS Subnet (Private)
resource "aws_subnet" "private" {
  # Reference the VPC created above using dot notation
  # aws_vpc.production.id creates an implicit dependency: subnet waits for VPC
  # This is Terraform's way of managing resource creation order
  vpc_id = aws_vpc.production.id

  # Subnet CIDR must be a subset of the VPC CIDR block
  # Example: if VPC is 10.0.0.0/16, subnet could be 10.0.1.0/24
  # This defines the IP range available to resources in this subnet
  cidr_block = var.subnet_cidr

  # Availability zones are physically separate data centers within a region
  # [0] selects the first AZ from the list (e.g., "us-east-1a")
  # Best practice: spread resources across multiple AZs for high availability
  availability_zone = data.aws_availability_zones.available.names[0]

  # map_public_ip_on_launch controls whether instances get public IPs automatically
  # false = private subnet (instances only get private IPs)
  # true = public subnet (instances get both private and public IPs)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Region      = data.aws_region.current.id
    # Tag with the specific AZ for easier troubleshooting and organization
    # This helps identify which AZ a resource is located in
    AZ = data.aws_availability_zones.available.names[0]
  }
}

# Resource: AWS Route Table
# Defines routing rules that control network traffic flow within the VPC
# Route tables determine where network traffic is directed from subnets
# Each subnet must be associated with a route table (if not specified, uses the default)
resource "aws_route_table" "private" {
  # Associate this route table with our VPC
  # Route tables are VPC-specific and control routing for subnets within that VPC
  vpc_id = aws_vpc.production.id

  # Note: This route table has no explicit routes defined yet
  # By default, VPCs include a local route for internal VPC communication
  # Additional routes (e.g., to NAT Gateway or VPN) would be added as separate resources
  # or within a 'route' block here

  tags = {
    Name        = "${var.environment}-route-table"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Region      = data.aws_region.current.region
  }
}