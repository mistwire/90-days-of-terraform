# ====================================================================
# VPC MODULE - main.tf
# ====================================================================
# This file contains the actual resources that the module creates
# Modules work like functions:
#   - Inputs: variables.tf defines what parameters the module accepts
#   - Processing: main.tf creates the resources using those inputs
#   - Outputs: outputs.tf defines what values the module returns
#
# This module creates a VPC and returns its ID and ARN

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr # Input variable from variables.tf

  tags = {
    Name = var.vpc_name # Input variable from variables.tf
  }
}

# The module consumer doesn't see this resource directly
# They only see what's exposed in outputs.tf
