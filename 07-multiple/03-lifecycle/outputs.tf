# Outputs for resources demonstrating different lifecycle behaviors

output "standard_bucket_name" {
  description = "Name of the standard S3 bucket (no lifecycle customizations)"
  value       = aws_s3_bucket.standard.bucket
}

output "protected_bucket_name" {
  description = "Name of the protected S3 bucket (prevent_destroy = true)"
  value       = aws_s3_bucket.protected.bucket
}

output "standard_dynamodb_name" {
  description = "Name of the standard DynamoDB table (no lifecycle customizations)"
  value       = aws_dynamodb_table.standard.name
}

output "replacement_dynamodb_name" {
  description = "Name of the replacement DynamoDB table (create_before_destroy = true)"
  value       = aws_dynamodb_table.replacement.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic (ignore_changes for Version tag)"
  value       = aws_sns_topic.updates.arn
}

# Educational output explaining the lifecycle configurations
output "lifecycle_examples" {
  description = "Examples of lifecycle configurations used"
  value = {
    "prevent_destroy"       = "S3 bucket: protected from terraform destroy"
    "create_before_destroy" = "DynamoDB table: new created before old destroyed (zero downtime)"
    "ignore_changes"        = "SNS Topic: ignores external changes to tags['Version']"
  }
}

