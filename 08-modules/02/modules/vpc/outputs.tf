# ====================================================================
# VPC MODULE - outputs.tf
# ====================================================================
# Module outputs define what values the module exposes to the caller
# These are the "return values" of the module
#
# Outputs are accessed by the module consumer using:
#   module.<module_name>.<output_name>
#
# Example:
#   module.vpc.vpc_id  # Accesses this output
#
# Only values defined in outputs.tf are accessible outside the module
# Internal resources and data are hidden (encapsulation)

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id # Exposes the VPC ID to module consumers
}

# You could add more outputs to expose additional attributes:
# output "vpc_arn" {
#   description = "The ARN of the VPC"
#   value       = aws_vpc.vpc.arn
# }
