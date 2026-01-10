variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Number type variable
# Used with count to create multiple resource instances
# This controls how many subnets will be created
variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 3
}

# list(string) type - a list of strings
# Each element is accessed by index: var.availability_zones[0], var.availability_zones[1], etc.
# Works perfectly with count.index to assign different values to each resource instance
variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Another list(string) for subnet CIDR blocks
# Length should match subnet_count for proper indexing
variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Complex Type: list(object({...}))
# This is a list where each element is an object with a defined structure
#
# Breaking it down:
# - list() = collection of multiple items accessed by index [0], [1], [2]...
# - object({...}) = structured data type with named properties
# - Each object MUST have the properties defined in the type constraint
#
# Why use list(object())?
# - Manage multiple complex configurations in a single variable
# - Each object can have different values but follows the same structure
# - Perfect for creating similar resources with different settings (like security groups)
# - Type safety: Terraform validates that each object has the required properties
#
# Access pattern: var.security_groups[index].property_name
# Example: var.security_groups[0].name = "web"
#          var.security_groups[1].ingress_port = 8080
variable "security_groups" {
  description = "Security group configurations"
  # Type definition: list of objects, each object has 3 required properties
  type = list(object({
    name         = string # Property 1: security group name
    description  = string # Property 2: description of what it's for
    ingress_port = number # Property 3: which port to allow inbound traffic
  }))
  # Default value: a list containing 3 objects
  # Each object represents a different security group configuration
  default = [
    # Object at index 0 - Web tier
    {
      name         = "web"
      description  = "Allow web traffic"
      ingress_port = 80
    },
    # Object at index 1 - Application tier
    {
      name         = "app"
      description  = "Allow application traffic"
      ingress_port = 8080
    },
    # Object at index 2 - Database tier
    {
      name         = "db"
      description  = "Allow database traffic"
      ingress_port = 3306
    }
  ]
}

variable "route_table_count" {
  description = "Number of route tables to create"
  type        = number
  default     = 2
}