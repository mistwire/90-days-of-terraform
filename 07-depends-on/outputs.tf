# Basic resource outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for logs"
  value       = aws_s3_bucket.logs.bucket
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web.id
}

# Educational output showing dependency types
# This output demonstrates the two types of dependencies in Terraform
output "dependency_example" {
  description = "Example of dependencies in this lab"
  value = {
    # IMPLICIT dependencies are created automatically when you reference another resource's attributes
    "Implicit dependencies" = "VPC -> Subnet, VPC -> IGW, IGW -> Route Table"

    # EXPLICIT dependencies are created manually using the depends_on meta-argument
    # Use depends_on when Terraform can't infer the dependency from resource references
    "Explicit dependencies (depends_on)" = "Route Table Association -> SG Rule, Bucket Policy -> Versioning -> Logging"

    # Dependency chain created by depends_on
    "S3 Dependency Chain" = "Bucket -> Policy (implicit) -> Versioning (explicit) -> Logging (explicit)"
  }
}