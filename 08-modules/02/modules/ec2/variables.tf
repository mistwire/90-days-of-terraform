variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-03f9680ef0c07a3d1"
}

variable "instance_type" {
  type        = string
  description = "The size of the instance to start"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "module-instance"
}