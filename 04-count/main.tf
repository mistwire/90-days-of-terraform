# Basic VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Resource with count Meta-Argument
# The count meta-argument creates multiple instances of a resource based on a number
# Instead of copy-pasting the same resource block 3 times, we use count to create them dynamically
#
# Key concepts:
# - count = <number> creates that many instances of the resource
# - Each instance gets a unique index: 0, 1, 2, etc.
# - Access instances with: resource_type.resource_name[index]
# - count.index provides the current iteration number (0-based)
#
# Why use count?
# - DRY principle: Define once, create many
# - Easy to scale: Change one number to create more/fewer resources
# - Consistent configuration: All instances follow the same pattern
resource "aws_subnet" "subnet" {
  # count creates var.subnet_count instances of this subnet resource
  # If var.subnet_count = 3, this creates subnet[0], subnet[1], subnet[2]
  count  = var.subnet_count
  vpc_id = aws_vpc.main.id

  # count.index accesses the current iteration (0, 1, 2...)
  # This lets us reference different values from our list variables
  # Example: When count.index = 0, uses var.subnet_cidr_blocks[0] = "10.0.1.0/24"
  #          When count.index = 1, uses var.subnet_cidr_blocks[1] = "10.0.2.0/24"
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    # count.index + 1 creates human-friendly numbering (subnet-1, subnet-2, subnet-3)
    # instead of zero-based (subnet-0, subnet-1, subnet-2)
    Name = "subnet-${count.index + 1}"
  }
}

# Advanced count Usage with Complex Object Lists
# This demonstrates using count with list(object()) variables
# Each iteration accesses a different object from the list with unique properties
#
# Pattern: var.list_name[count.index].property_name
# This allows each resource instance to have different configurations
# while still being created from a single resource block
resource "aws_security_group" "sg" {
  # Hard-coded count of 3 matches the length of var.security_groups default list
  # In production, you might use: count = length(var.security_groups)
  # to automatically match the list length
  count = 3

  # Accessing object properties with dot notation
  # var.security_groups[count.index] gets the entire object at that index
  # .name, .description, .ingress_port access specific properties of that object
  #
  # Example for count.index = 0:
  #   var.security_groups[0].name = "web"
  #   var.security_groups[0].description = "Allow web traffic"
  #   var.security_groups[0].ingress_port = 80
  name        = "${var.security_groups[count.index].name}-sg"
  description = var.security_groups[count.index].description
  vpc_id      = aws_vpc.main.id

  ingress {
    # Each security group gets a different port based on its configuration object
    # SG 0 gets port 80 (web), SG 1 gets port 8080 (app), SG 2 gets port 3306 (db)
    from_port   = var.security_groups[count.index].ingress_port
    to_port     = var.security_groups[count.index].ingress_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.security_groups[count.index].name}-sg"
  }
}

# Multiple Route Tables with count
# Simple example of count for creating identical resources with only naming differences
resource "aws_route_table" "example" {
  count  = var.route_table_count
  vpc_id = aws_vpc.main.id

  tags = {
    # Using count.index for sequential naming
    Name = "route-table-${count.index + 1}"
  }
}