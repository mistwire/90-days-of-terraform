# ====================================================================
# MODULE COMPOSITION
# ====================================================================
# Module composition is the practice of building complex infrastructure
# by combining multiple small, focused modules together
#
# Benefits:
# - Single Responsibility: Each module does one thing well
# - Reusability: Mix and match modules for different use cases
# - Testability: Easier to test small, focused modules
# - Flexibility: Compose modules in different ways for different scenarios
#
# Pattern: Create separate modules for policies and roles, then compose them
# This is better than one monolithic "IAM" module

# ====================================================================
# STEP 1: Create IAM Policies (using iam_policy module)
# ====================================================================
# These modules create standalone IAM policies
# Policies define permissions but don't grant them to anyone yet

# Policy Module #1: S3 Read-Only Access
# Creates an IAM policy allowing read access to S3 buckets
module "s3_read_only_policy" {
  source             = "./modules/iam_policy" # Local module for creating IAM policies
  environment        = var.environment
  policy_name        = "s3-read-only"
  policy_description = "Allow read-only access to S3"

  # Policy statements define what actions are allowed/denied
  # This is a list of objects - the module will convert it to JSON
  policy_statements = [
    {
      effect    = "Allow"
      actions   = ["s3:Get*", "s3:List*"] # All S3 read operations
      resources = ["*"]                   # On all S3 resources
    }
  ]
}
# Module output: module.s3_read_only_policy.policy_arn

# Policy Module #2: CloudWatch Write Access
# Creates an IAM policy allowing write access to CloudWatch Logs
module "cloudwatch_write_policy" {
  source             = "./modules/iam_policy"
  environment        = var.environment
  policy_name        = "cloudwatch-write"
  policy_description = "Allow CloudWatch write access"

  policy_statements = [
    {
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["*"]
    }
  ]
}
# Module output: module.cloudwatch_write_policy.policy_arn

# ====================================================================
# STEP 2: Create IAM Roles and Attach Policies (using iam_role module)
# ====================================================================
# These modules create IAM roles and attach the policies created above
# This demonstrates MODULE COMPOSITION - combining outputs from one module
# as inputs to another module

# Role Module #1: Application Role with S3 Access
# Creates a role for EC2 instances and attaches the S3 read-only policy
module "app_role" {
  source            = "./modules/iam_role" # Local module for creating IAM roles
  environment       = var.environment
  role_name         = "app-role"
  role_description  = "Application role"
  trusted_principal = "ec2.amazonaws.com" # This role can be assumed by EC2 instances

  # COMPOSITION: Using output from the s3_read_only_policy module
  # This creates a dependency: policy must be created before role
  policy_arns = [module.s3_read_only_policy.policy_arn]
}

# Role Module #2: Monitoring Role with CloudWatch Access
# Creates a role for Lambda functions and attaches the CloudWatch write policy
module "monitoring_role" {
  source            = "./modules/iam_role"
  environment       = var.environment
  role_name         = "monitoring-role"
  role_description  = "Monitoring role"
  trusted_principal = "lambda.amazonaws.com" # This role can be assumed by Lambda

  # COMPOSITION: Using output from the cloudwatch_write_policy module
  policy_arns = [module.cloudwatch_write_policy.policy_arn]
}

# ====================================================================
# MODULE COMPOSITION BENEFITS
# ====================================================================
# 1. The policy modules can be reused for different roles
# 2. Roles can combine multiple policies: policy_arns = [policy1, policy2, policy3]
# 3. Each module is simple and focused (single responsibility)
# 4. Easy to test each module independently
# 5. Clear dependency chain: policies -> roles
