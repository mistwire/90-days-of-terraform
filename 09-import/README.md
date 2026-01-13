# Day 9: Terraform Import

## Overview

This example demonstrates Terraform's import functionality, which allows you to bring existing infrastructure under Terraform management.

## What is Terraform Import?

Terraform import is used when you have resources that were created outside of Terraform (manually, by other tools, or by other teams) and you want to manage them with Terraform going forward.

## Two Methods of Import

### 1. Legacy CLI Method (Still Works, Not Recommended)

```bash
# Old way - imperative command
terraform import aws_vpc.my_vpc vpc-12345678
```

**Drawbacks:**
- Must be run manually
- Not version controlled
- Not repeatable
- Doesn't generate configuration
- Easy to forget or make mistakes

### 2. Modern Import Blocks (Terraform 1.5+, Recommended)

```hcl
# New way - declarative in code
import {
  to = aws_vpc.my_vpc
  id = "vpc-12345678"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  # ... configuration must match existing resource
}
```

**Benefits:**
- Declarative (defined in code)
- Version controlled
- Repeatable
- Can use -generate-config-out to auto-generate configuration

## The -generate-config-out Feature

The `-generate-config-out` flag automatically generates resource configuration for you.

### Workflow:

#### Step 1: Create the import block only
```hcl
# import.tf
import {
  to = aws_vpc.my_vpc
  id = "vpc-12345678"
}
```

#### Step 2: Run terraform plan with -generate-config-out
```bash
terraform plan -generate-config-out=generated.tf
```

#### Step 3: Review generated.tf
Terraform creates this file with the resource configuration:

```hcl
# generated.tf (auto-created)
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}
```

#### Step 4: Adjust the configuration
- Remove read-only/computed attributes
- Update tags or values as needed
- Add lifecycle rules if needed
- Move to appropriate file

#### Step 5: Apply the import
```bash
terraform plan  # Verify no changes
terraform apply # Complete the import
```

#### Step 6: Clean up
Remove the import block from `import.tf` - it's only needed once.

## Hands-On Exercise

### Creating Resources to Import

1. **Create the example resources:**
   ```bash
   terraform init
   terraform apply
   ```

   This creates a VPC, S3 bucket, and DynamoDB table.

2. **Simulate "manual creation" by removing them from state:**
   ```bash
   # Remove from Terraform state (but keep in AWS)
   terraform state rm aws_vpc.example
   terraform state rm aws_s3_bucket.example
   terraform state rm aws_dynamodb_table.example
   ```

   Now these resources exist in AWS but Terraform doesn't know about them.

### Importing Resources Back

#### Method 1: Manual Configuration

1. Get the resource IDs:
   ```bash
   # VPC ID
   aws ec2 describe-vpcs --filters "Name=tag:Name,Values=import-example-vpc" \
     --query 'Vpcs[0].VpcId' --output text

   # S3 Bucket (just the name)
   aws s3 ls | grep import-example-bucket

   # DynamoDB Table (just the name)
   aws dynamodb list-tables | grep import-example-table
   ```

2. Create import block in `import.tf`:
   ```hcl
   import {
     to = aws_vpc.example
     id = "vpc-abc123xyz"  # Your actual VPC ID
   }
   ```

3. The resource configuration already exists in `main.tf`, so just run:
   ```bash
   terraform plan
   terraform apply
   ```

#### Method 2: Auto-Generate Configuration

1. Create import block WITHOUT resource configuration:
   ```hcl
   import {
     to = aws_vpc.reimported
     id = "vpc-abc123xyz"
   }
   ```

2. Generate the configuration:
   ```bash
   terraform plan -generate-config-out=generated.tf
   ```

3. Review and adjust `generated.tf`

4. Apply the import:
   ```bash
   terraform apply
   ```

## Finding Resource IDs

Different AWS resources use different ID formats:

| Resource Type | ID Format | How to Find |
|--------------|-----------|-------------|
| VPC | `vpc-xxxxxxxxx` | AWS Console VPC Dashboard or `aws ec2 describe-vpcs` |
| Subnet | `subnet-xxxxxxxxx` | `aws ec2 describe-subnets` |
| Security Group | `sg-xxxxxxxxx` | `aws ec2 describe-security-groups` |
| EC2 Instance | `i-xxxxxxxxx` | `aws ec2 describe-instances` |
| S3 Bucket | bucket-name | `aws s3 ls` (just the bucket name) |
| DynamoDB Table | table-name | `aws dynamodb list-tables` (just the table name) |
| IAM Role | role-name | `aws iam list-roles` (just the role name) |

Check the [Terraform AWS Provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for the exact ID format for each resource type.

## Common Import Scenarios

### Scenario 1: Migrating Manually Created Resources
Resources were created in the AWS console, now you want Terraform to manage them.

### Scenario 2: Recovering from Lost State
You lost your `terraform.tfstate` file but resources still exist in AWS.

### Scenario 3: Taking Over from Another Tool
Resources were created by CloudFormation, CDK, or another IaC tool.

### Scenario 4: Multi-Team Collaboration
Another team created resources, you need to include them in your Terraform config.

## Best Practices

1. **Always use import blocks** (Terraform 1.5+) instead of CLI import
2. **Use -generate-config-out** to automatically generate accurate configuration
3. **Import incrementally** - don't try to import everything at once
4. **Test in non-production** first
5. **Review generated config** for sensitive data before committing
6. **Document imports** - comment why resources were imported
7. **Remove import blocks** after successful import
8. **Version control import blocks** before removing them

## Troubleshooting

### Error: "resource already managed by Terraform"
Check if already in state:
```bash
terraform state list
```

### Error: "resource does not exist"
- Verify the resource ID is correct
- Check you're in the correct AWS region
- Verify the resource actually exists in AWS

### Error: "configuration doesn't match resource"
Run terraform plan to see differences, then update your configuration to match.

### Sensitive Values Not Available
Some values (passwords, keys) cannot be imported. Set them manually or use:
```hcl
lifecycle {
  ignore_changes = [password]
}
```

## Files in This Example

- `providers.tf` - Provider configuration
- `variables.tf` - Input variables
- `main.tf` - Example resources and detailed import documentation
- `import.tf` - Import block examples and comprehensive guide
- `outputs.tf` - Resource outputs
- `README.md` - This file

## Additional Resources

- [Terraform Import Documentation](https://developer.hashicorp.com/terraform/language/import)
- [Import Blocks Tutorial](https://developer.hashicorp.com/terraform/tutorials/state/state-import)
- [AWS Provider Import Guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
