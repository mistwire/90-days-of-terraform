# VPC output - single resource
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# ====================================================================
# Outputs for count-based resources
# ====================================================================

# Using the splat operator [*] to get all IDs from count-based resources
# This returns a list: ["subnet-id-1", "subnet-id-2"]
# The order matches the count.index order
output "subnet_count_ids" {
  description = "The IDs of the count-based subnets"
  value       = aws_subnet.subnet[*].id # Splat operator gets all instances
}

# ====================================================================
# Outputs for for_each-based resources
# ====================================================================

# Outputting the entire resource object for for_each resources
# This returns a map: {"public" = {entire subnet object}, "private1" = {entire subnet object}}
# Each key in the output corresponds to the for_each key
output "subnet_foreach_ids" {
  description = "The IDs of the for_each-based subnets"
  value       = aws_subnet.subnet_foreach # Returns map of all subnet objects
}

# To get just the IDs in a map format, you could use:
# value = { for k, v in aws_subnet.subnet_foreach : k => v.id }

output "security_group_foreach_ids" {
  description = "The IDs of the for_each-based security groups"
  value       = aws_security_group.sg_foreach # Returns map of all security group objects
}

# ====================================================================
# Outputs for simple map-based resources
# ====================================================================

output "route_table_ids" {
  description = "The IDs of the map-based route tables"
  value       = aws_route_table.rt # Returns map: {"public" = {...}, "private1" = {...}, "private2" = {...}}
}

