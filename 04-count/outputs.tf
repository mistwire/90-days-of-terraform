output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Splat Expression: [*]
# The splat operator [*] extracts an attribute from ALL instances of a resource created with count
#
# Without count (single resource):
#   aws_vpc.main.id returns a single string
#
# With count (multiple instances):
#   aws_subnet.subnet[0].id returns the ID of the first subnet
#   aws_subnet.subnet[1].id returns the ID of the second subnet
#   aws_subnet.subnet[*].id returns a LIST of ALL subnet IDs
#
# Syntax: resource_type.resource_name[*].attribute_name
#
# What it does:
# - Iterates through all instances (subnet[0], subnet[1], subnet[2])
# - Extracts the specified attribute (.id) from each instance
# - Returns a list of those values
#
# Example result for subnet_ids:
#   ["subnet-abc123", "subnet-def456", "subnet-ghi789"]
#
# Why use splat expressions?
# - Get all values at once without manually indexing each instance
# - Perfect for passing lists of IDs to other resources or modules
# - More maintainable: works regardless of how many instances exist
output "subnet_ids" {
  description = "The IDs of the subnets"
  # Returns: ["subnet-xxx", "subnet-yyy", "subnet-zzz"]
  value = aws_subnet.subnet[*].id
}

# Another splat expression example
# Extracts the cidr_block attribute from all subnet instances
output "subnet_cidr_blocks" {
  description = "The CIDR blocks of the subnets"
  # Returns: ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  value = aws_subnet.subnet[*].cidr_block
}

# Splat expression with security groups
# Gets all security group IDs created by the count loop
output "security_group_ids" {
  description = "The IDs of the security groups"
  # Returns: ["sg-web123", "sg-app456", "sg-db789"]
  value = aws_security_group.sg[*].id
}

# Splat expression with route tables
output "route_table_ids" {
  description = "The IDs of the route tables"
  # Returns: ["rtb-111", "rtb-222"]
  value = aws_route_table.example[*].id
}