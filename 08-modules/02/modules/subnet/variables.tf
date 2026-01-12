variable "vpc_id" {
  type    = string
  default = "The ID of the VPC"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "module-subnet"
}

variable "availability_zone" {
  description = "AZ for the subnet"
  type        = string
  default     = "us-east-1a"
}