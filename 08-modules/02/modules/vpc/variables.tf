# ====================================================================
# VPC MODULE - variables.tf
# ====================================================================
# Module input variables define what parameters the module accepts
# When calling a module, these become the module's arguments
#
# Example module call:
#   module "vpc" {
#     source   = "./modules/vpc"
#     vpc_name = "my-vpc"       # <- Sets var.vpc_name in the module
#     vpc_cidr = "10.0.0.0/16"  # <- Sets var.vpc_cidr in the module
#   }
#
# Default values make variables optional when calling the module

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "terraform-modules-vpc" # If not provided, uses this default
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC module"
  type        = string
  default     = "10.0.0.0/16" # Default CIDR if not specified
}
