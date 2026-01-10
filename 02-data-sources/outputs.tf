# Output Block: VPC ID
# Outputs expose values from your infrastructure for use by other configurations
# or for display to users after deployment
# The value can be retrieved using: terraform output vpc_id
output "vpc_id" {
  description = "ID of the created VPC"
  # aws_vpc.production.id references the unique identifier AWS assigned to our VPC
  value = aws_vpc.production.id
}

# Output Block: Subnet ID
# Useful for referencing this subnet in other Terraform modules or configurations
output "subnet_id" {
  description = "ID of the created subnet"
  # Subnet IDs follow the format: subnet-xxxxxxxxxxxxxxxxx
  # This can be used to launch EC2 instances or other resources into this specific subnet
  value = aws_subnet.private.id
}

# Output Block: Availability Zone
# Shows which AZ the subnet was created in
# Important for understanding resource distribution and planning multi-AZ deployments
output "availability_zone" {
  description = "Availability zone of the subnet"
  # Returns the AZ name (e.g., "us-east-1a", "us-west-2b")
  value = aws_subnet.private.availability_zone
}

# Output Block: Account Information
# Combines multiple data source values into a human-readable format
# Useful for confirming which account and region you deployed to
output "account_info" {
  description = "AWS Account Information"
  # String interpolation combining account ID and region name
  # This provides a quick way to verify deployment context
  value = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}"
}