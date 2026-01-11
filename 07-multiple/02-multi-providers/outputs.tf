# Outputs demonstrating multi-region resource deployment
# Each output shows resources created in different AWS regions using provider aliases

output "primary_bucket_name" {
  description = "Name of the S3 bucket in the primary region"
  value       = aws_s3_bucket.primary.bucket
}

output "secondary_bucket_name" {
  description = "Name of the S3 bucket in the secondary region"
  value       = aws_s3_bucket.secondary.bucket
}

# The .region attribute shows which region each resource was created in
# This confirms the provider alias worked correctly
output "primary_bucket_region" {
  description = "Region of the primary S3 bucket"
  value       = aws_s3_bucket.primary.region  # Should match var.primary_region
}

output "secondary_bucket_region" {
  description = "Region of the secondary S3 bucket"
  value       = aws_s3_bucket.secondary.region  # Should match var.secondary_region
}

output "primary_sns_topic_arn" {
  description = "ARN of the SNS topic in the primary region"
  value       = aws_sns_topic.primary.arn
}

output "secondary_sns_topic_arn" {
  description = "ARN of the SNS topic in the secondary region"
  value       = aws_sns_topic.secondary.arn
}