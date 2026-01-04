# Terraform Block
# Configures Terraform behavior, including required provider versions
# and backend configuration for state management
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # ~> is the "pessimistic constraint operator"
      # ~> 5.0 means: >= 5.0.0 AND < 6.0.0
      # This allows minor and patch updates but prevents major version upgrades
      # that might introduce breaking changes
      version = "~> 5.0"
    }
  }
}

# Provider Block
# Configures a specific provider (in this case, AWS)
# Providers are plugins that interact with cloud APIs and manage resources
provider "aws" {
  # This is a variable reference using the "var." prefix
  # var.<variable_name> allows you to use values defined in variable blocks
  # This makes configurations dynamic and reusable across environments
  region = var.aws_region

  # In production, you would configure credentials here or use environment variables
  # default_tags can be added here to tag all resources
}

# Variable Block
# Defines input variables that can be passed into your Terraform configuration
# Variables make your code reusable and configurable across environments
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-demo"
}

# Data Block
# Retrieves information from existing resources or external data sources
# Data sources are read-only and don't create or modify infrastructure
# They're used to fetch information that already exists in your cloud environment
data "aws_availability_zones" "available" {
  state = "available"
  # This fetches all available AZs in the current region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  # Filter blocks allow you to narrow down data source queries
  # They work like search criteria, specifying conditions the results must match
  # Multiple filters create an AND condition (all must match)
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  # This fetches the most recent Amazon Linux 2 AMI
}

# Resource Block
# Defines infrastructure components to create, update, or delete
# Resources are the core building blocks of your infrastructure
resource "aws_vpc" "main" {
  # CIDR (Classless Inter-Domain Routing) defines the IP address range for your network
  # Format: IP/prefix (e.g., 10.0.0.0/16)
  # /16 means the first 16 bits are fixed, giving you 65,536 IP addresses (2^16)
  # Smaller numbers = more IPs (/8 = huge), larger numbers = fewer IPs (/24 = 256)
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    # String interpolation using ${...} syntax
    # This combines multiple variables and literal strings into one value
    # Example result: "terraform-demo-dev-vpc"
    # The ${} syntax evaluates the expression inside and inserts it into the string
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count             = 2
  # Dot notation (resource_type.resource_name.attribute) references other resources
  # Format: <resource_type>.<local_name>.<attribute>
  # Here we're accessing the 'id' attribute of the VPC resource we created above
  # This creates an implicit dependency: subnets wait for VPC to be created first
  vpc_id            = aws_vpc.main.id
  # cidrsubnet() function calculates subnet CIDR blocks from a parent CIDR
  # Syntax: cidrsubnet(prefix, newbits, netnum)
  # Example: cidrsubnet("10.0.0.0/16", 8, 0) = "10.0.0.0/24"
  #          cidrsubnet("10.0.0.0/16", 8, 1) = "10.0.1.0/24"
  # newbits=8 extends /16 to /24 (16+8), netnum=count.index selects which subnet
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Output Block
# Exposes values from your Terraform configuration after deployment
# Outputs can be used by other Terraform configurations, displayed to users,
# or accessed via 'terraform output' command
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "List of subnet IDs created"
  # The [*] is the "splat operator" (also called "for-all" operator)
  # When a resource uses 'count', it creates multiple instances
  # [*] iterates over all instances and extracts the specified attribute
  # This returns a list: ["subnet-id-1", "subnet-id-2"] instead of one value
  value       = aws_subnet.public[*].id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = data.aws_availability_zones.available.names
}

output "amazon_linux_ami_id" {
  description = "The AMI ID of the latest Amazon Linux 2"
  value       = data.aws_ami.amazon_linux.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}
