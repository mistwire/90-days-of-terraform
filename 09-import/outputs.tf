# Outputs for the example resources
# These would show the imported resource details after import

output "example_vpc_id" {
  description = "ID of the example VPC"
  value       = aws_vpc.example.id
}

output "example_bucket_name" {
  description = "Name of the example S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "example_table_name" {
  description = "Name of the example DynamoDB table"
  value       = aws_dynamodb_table.example.name
}

# After importing resources, you can access them like any other Terraform resource
# For example, if you import a VPC with: import { to = aws_vpc.imported_vpc, id = "vpc-123" }
# You can then output:
#
# output "imported_vpc_id" {
#   value = aws_vpc.imported_vpc.id
# }
