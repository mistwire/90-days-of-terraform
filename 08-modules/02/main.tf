# ====================================================================
# LOCAL CUSTOM MODULES
# ====================================================================
# Modules don't have to come from the registry - you can create your own!
# Local modules use a relative path as the source
# Module structure:
#   ./modules/module_name/
#     ├── main.tf       (resources to create)
#     ├── variables.tf  (input variables)
#     └── outputs.tf    (output values)
#
# Benefits of custom modules:
# - Encapsulate and reuse common patterns in your organization
# - Enforce standards and best practices
# - Simplify complex configurations
# - Create abstractions that hide implementation details

# Module 1: Custom VPC Module
# Source uses a relative path to the local module directory
module "vpc" {
  source   = "./modules/vpc" # Local module path (relative to current directory)
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "module-vpc"
}
# Module outputs can be referenced: module.vpc.vpc_id, module.vpc.vpc_arn, etc.

# ====================================================================
# MODULE DEPENDENCY CHAIN
# ====================================================================
# Modules can depend on each other's outputs
# Here: VPC -> Subnet -> EC2 (dependency chain)

# Module 2: Custom Subnet Module
# Depends on the VPC module's output (vpc_id)
module "subnet-module" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id # Output from VPC module (creates implicit dependency)
  subnet_cidr       = "10.0.1.0/24"
  subnet_name       = "subnet-from-module"
  availability_zone = "us-east-1a"
}

# Module 3: Custom EC2 Module
# Depends on both VPC and Subnet module outputs
# Terraform automatically creates the correct order: VPC -> Subnet -> EC2
module "prod-server" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc.vpc_id              # From VPC module
  subnet_id = module.subnet-module.subnet_id # From Subnet module

}

# KEY CONCEPTS:
# 1. Local modules use relative paths: "./modules/name" or "../shared/name"
# 2. After adding/changing modules, run: terraform init
# 3. Module outputs create implicit dependencies (Terraform knows the order)
# 4. Modules make code DRY (Don't Repeat Yourself)
