# Main VPC
# This VPC serves as the network container for all our resources
# All subnets, security groups, and route tables will be created within this VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Subnets created with count meta-argument
# The count meta-argument creates multiple instances of a resource based on a number
# Resources are accessed by index: aws_subnet.subnet[0], aws_subnet.subnet[1], etc.
# WARNING: If you remove an item from the middle of the list, all subsequent items
# shift indexes, causing Terraform to destroy and recreate those resources!
resource "aws_subnet" "subnet" {
  count             = 2  # Creates 2 subnet instances
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]  # Access list elements by index
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "subnet-${count.index + 1}"  # count.index is 0-based, so add 1 for human-readable names
    # Ternary operator: condition ? value_if_true : value_if_false
    # If count.index < 1 (i.e., index is 0), then "public", else "private"
    # Result: subnet[0] gets Tier="public", subnet[1] gets Tier="private"
    Tier = count.index < 1 ? "public" : "private"
  }
}

# Security groups created with count
# Demonstrates creating multiple security groups using the count meta-argument
# Each security group is named based on its corresponding value in the security_groups list
resource "aws_security_group" "sg" {
  count       = 3  # Creates 3 security group instances
  name        = "${var.security_groups[count.index]}-sg"  # web-sg, app-sg, db-sg
  description = "Security group for ${var.security_groups[count.index]}"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.security_groups[count.index]}-sg"
  }
}

# Security group rules created with count
# Creates ingress (inbound) rules for each security group
# Each rule allows traffic on a specific port from anywhere (0.0.0.0/0)
resource "aws_security_group_rule" "ingress" {
  count             = 3  # Creates 3 ingress rules
  type              = "ingress"  # Inbound traffic
  from_port         = var.sg_ports[count.index]  # Port 80, 8080, or 3306
  to_port           = var.sg_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Allow from anywhere (not recommended for production!)
  security_group_id = aws_security_group.sg[count.index].id  # Reference to the security group by index
}

# Subnets created with for_each meta-argument
# The for_each meta-argument creates multiple instances from a map or set
# Resources are accessed by key: aws_subnet.subnet_foreach["public"], aws_subnet.subnet_foreach["private1"], etc.
# ADVANTAGE: Adding/removing items doesn't affect other resources because each has a stable key-based address
# Use each.key to access the map key and each.value to access the map value
resource "aws_subnet" "subnet_foreach" {
  for_each          = var.subnet_config  # Iterates over the map: {"public" = "10.0.10.0/24", "private1" = "10.0.20.0/24"}
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value  # The CIDR block from the map value
  availability_zone = var.subnet_azs[each.key]  # Lookup AZ using the key from another map

  tags = {
    Name = "subnet-${each.key}"  # each.key is "public", "private1", etc.
    Tier = "standard"
  }
}

# Security groups created with for_each
# Demonstrates using for_each with a map where keys are security group names and values are port numbers
# This is more flexible than count because you can add/remove security groups without affecting others
resource "aws_security_group" "sg_foreach" {
  for_each    = var.security_group_config  # {"web" = 80, "app" = 8080, "db" = 3306, "cache" = 6379}
  name        = "${each.key}-sg-foreach"  # web-sg-foreach, app-sg-foreach, etc.
  description = "Security group for ${each.key} servers"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${each.key}-sg-foreach"
  }
}

# Security group rules created with for_each
# Creates ingress rules using the same map, where each.value is the port number
# Shows how for_each can reference both the key and value from the map
resource "aws_security_group_rule" "ingress_foreach" {
  for_each          = var.security_group_config  # Same map as above
  type              = "ingress"
  from_port         = each.value  # Port number from the map value (80, 8080, 3306, 6379)
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_foreach[each.key].id  # Reference using the key
}

# Route tables created with for_each and a simple map
# Demonstrates using for_each where the value is just a description string
# Each route table gets a unique name based on the key and a description from the value
resource "aws_route_table" "rt" {
  for_each = var.route_tables  # {"public" = "Public route table", "private1" = "Private route table 1", ...}
  vpc_id   = aws_vpc.main.id

  tags = {
    Name        = "${each.key}-rt"  # public-rt, private1-rt, private2-rt
    Description = each.value  # Description from the map value
  }
}