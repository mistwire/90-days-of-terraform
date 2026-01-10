# ====================================================================
# Variables for count-based resources
# These demonstrate the limitations of count when used with lists
# ====================================================================

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  # DANGER: If you remove "10.0.2.0/24" from the middle, the 3rd element becomes the 2nd
  # This causes Terraform to destroy subnet[2] and recreate subnet[1] with new values!
  default     = ["10.0.1.0/24", "10.0.2.0/24"]#, "10.0.3.0/24"] <- removed 3rd element
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "security_groups" {
  description = "Security group names"
  type        = list(string)
  default     = ["web", "app", "db"]
}

variable "sg_ports" {
  description = "Ports for security group rules"
  type        = list(number)
  default     = [80, 8080, 3306]
}

# ====================================================================
# Variables for for_each-based resources
# These demonstrate the advantages of for_each when using maps
# ====================================================================

variable "subnet_config" {
  description = "Map of subnet configurations"
  type        = map(string)  # Map where keys are subnet names, values are CIDR blocks
  # BENEFIT: You can comment out "private2" and only that specific subnet is affected
  # No other subnets are touched because they have stable key-based addresses
  default = {
    "public"   = "10.0.10.0/24"
    "private1" = "10.0.20.0/24"
    # "private2" = "10.0.30.0/24"  # Commenting this out only removes the private2 subnet
  }
}

variable "subnet_azs" {
  description = "Map of subnet availability zones"
  type        = map(string)  # Map where keys match subnet_config keys, values are AZ names
  # The keys here should match the keys in subnet_config for proper lookup
  default = {
    "public"   = "us-east-1a"
    "private1" = "us-east-1b"
    # "private2" = "us-east-1c"
  }
}

variable "security_group_config" {
  description = "Map of security group ports"
  type        = map(number)  # Map where keys are SG names, values are port numbers
  # BENEFIT: Adding "cache" here creates a new security group without affecting existing ones
  # With count, this would require careful list management to avoid resource recreation
  default = {
    "web" = 80      # HTTP
    "app" = 8080    # Application server
    "db"  = 3306    # MySQL
    "cache" = 6379  # Redis - new item added without affecting other security groups!
  }
}

variable "route_tables" {
  description = "Map of route tables to create"
  type        = map(string)  # Map where keys are route table names, values are descriptions
  default = {
    "public"   = "Public route table"
    "private1" = "Private route table 1"
    "private2" = "Private route table 2"
  }
}