# ====================================================================
# BUILT-IN FUNCTION: join()
# ====================================================================
# join() concatenates list elements into a string with a separator
# Syntax: join(separator, list)
# Example: join("-", ["dev", "vpc"]) returns "dev-vpc"

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = join("-", [var.environment, "vpc"])
    # join("-", ["dev", "vpc"]) produces "dev-vpc"
  }
}

# ====================================================================
# BUILT-IN FUNCTIONS: min() and length()
# ====================================================================
# length() returns the number of elements in a collection
# min() returns the smallest number from the arguments
# This pattern prevents count from exceeding available resources

resource "aws_subnet" "main" {
  # min() ensures we don't exceed either list's length
  # If availability_zones has 3 items and subnet_cidrs has 2, min returns 2
  count             = min(length(var.availability_zones), length(var.subnet_cidrs))
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-subnet-${count.index + 1}"
  }
}

# ====================================================================
# BUILT-IN FUNCTION: toset()
# ====================================================================
# toset() converts a list to a set, automatically removing duplicates
# Sets only contain unique values, unlike lists which allow duplicates
# Example: toset(["a", "b", "a", "c"]) returns {"a", "b", "c"}

locals {
  unique_teams = toset(var.teams)  # Removes duplicate team names
}

# Security group demonstrating use of the unique teams set
resource "aws_security_group" "example" {
  name        = "${var.environment}-security-group"
  description = "Example security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name  = "${var.environment}-security-group"
    Teams = join(", ", local.unique_teams)
    # First toset() removes duplicates, then join() creates comma-separated string
  }
}

