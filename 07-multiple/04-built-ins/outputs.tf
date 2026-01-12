# Outputs demonstrating Terraform built-in functions

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Demonstrates min() and length() functions
# min() returns the smaller of the two list lengths
output "subnet_count" {
  description = "Number of subnets created (using min function)"
  value       = min(length(var.availability_zones), length(var.subnet_cidrs))
}

# Demonstrates toset() function for removing duplicates
# The set type only contains unique values
output "unique_teams" {
  description = "List of unique teams (using toset function)"
  value       = local.unique_teams
}

# Demonstrates join() function for concatenating strings
# The VPC name was created using join("-", [var.environment, "vpc"])
output "vpc_name" {
  description = "VPC name (created with join function)"
  value       = aws_vpc.main.tags.Name
}

output "security_group_name" {
  description = "Security group name (created with join function)"
  value       = aws_security_group.example.name
}

# Example output showing multiple functions working together
output "function_examples" {
  description = "Demonstrates multiple built-in functions"
  value = {
    # join() concatenates list elements with a separator
    "join_example" = join("-", [var.environment, "vpc"])

    # length() returns collection size
    "length_example" = length(var.availability_zones)

    # toset() removes duplicates from a list
    "toset_example" = toset(var.teams)

    # min() returns the smallest number
    "min_example" = min(length(var.availability_zones), length(var.subnet_cidrs))
  }
}