# Terraform Built-in Functions Reference

Terraform includes many built-in functions for manipulating and transforming data. Functions are called using the syntax: `function_name(arg1, arg2, ...)`. This guide covers the most commonly used functions.

---

## String Functions

### `join(separator, list)`
Concatenates list elements into a string with a separator.
```hcl
join("-", ["dev", "vpc", "subnet"])
# Result: "dev-vpc-subnet"

tags = {
  Name = join("-", [var.environment, var.service, "instance"])
}
```

### `split(separator, string)`
Splits a string into a list based on a separator.
```hcl
split(",", "us-east-1,us-west-2,eu-west-1")
# Result: ["us-east-1", "us-west-2", "eu-west-1"]

availability_zones = split(",", var.az_string)
```

### `format(format_string, args...)`
Formats a string using printf-style formatting.
```hcl
format("instance-%03d", 42)
# Result: "instance-042"

format("%s-%s-bucket", var.environment, var.region)
# Result: "dev-us-east-1-bucket"
```

### `lower(string)` / `upper(string)` / `title(string)`
Changes string case.
```hcl
lower("HELLO-WORLD")  # Result: "hello-world"
upper("hello-world")  # Result: "HELLO-WORLD"
title("hello world")  # Result: "Hello World"

bucket = lower("${var.CompanyName}-${var.Project}")
```

### `replace(string, search, replace)`
Replaces occurrences of a substring.
```hcl
replace("hello_world", "_", "-")
# Result: "hello-world"

sanitized_name = replace(var.user_input, " ", "-")
```

### `trim(string, characters)` / `trimspace(string)`
Removes characters from string edges.
```hcl
trim("...hello...", ".")   # Result: "hello"
trimspace("  hello  ")     # Result: "hello"

clean_name = trimspace(var.name)
```

### `substr(string, offset, length)`
Extracts a substring.
```hcl
substr("hello-world", 0, 5)   # Result: "hello"
substr("hello-world", 6, -1)  # Result: "world" (negative length = to end)

short_id = substr(aws_instance.example.id, 0, 8)
```

---

## Collection Functions

### `length(collection)`
Returns the number of elements.
```hcl
length(["a", "b", "c"])           # Result: 3
length({"key" = "value"})         # Result: 1
length("hello")                   # Result: 5

count = length(var.availability_zones)
```

### `concat(list1, list2, ...)`
Combines multiple lists into one.
```hcl
concat(["a", "b"], ["c", "d"])
# Result: ["a", "b", "c", "d"]

all_zones = concat(var.public_zones, var.private_zones)
```

### `merge(map1, map2, ...)`
Combines multiple maps into one (later values override earlier ones).
```hcl
merge(
  {name = "example", env = "dev"},
  {env = "prod", region = "us-east-1"}
)
# Result: {name = "example", env = "prod", region = "us-east-1"}

tags = merge(var.common_tags, var.specific_tags)
```

### `lookup(map, key, default)`
Retrieves a value from a map with an optional default.
```hcl
lookup({a = "alpha", b = "beta"}, "a", "unknown")     # Result: "alpha"
lookup({a = "alpha", b = "beta"}, "c", "unknown")     # Result: "unknown"

instance_type = lookup(var.instance_types, var.environment, "t3.micro")
```

### `keys(map)` / `values(map)`
Returns map keys or values as a list.
```hcl
keys({a = 1, b = 2})     # Result: ["a", "b"]
values({a = 1, b = 2})   # Result: [1, 2]

subnet_names = keys(var.subnet_config)
```

### `element(list, index)`
Retrieves an element by index (wraps around if index > length).
```hcl
element(["a", "b", "c"], 1)  # Result: "b"
element(["a", "b", "c"], 5)  # Result: "c" (wraps: 5 % 3 = 2)

availability_zone = element(var.azs, count.index)
```

### `contains(list, value)`
Checks if a list contains a value.
```hcl
contains(["a", "b", "c"], "b")  # Result: true
contains(["a", "b", "c"], "d")  # Result: false

is_production = contains(var.prod_accounts, var.account_id)
```

### `flatten(list_of_lists)`
Flattens nested lists into a single list.
```hcl
flatten([["a", "b"], ["c", "d"]])
# Result: ["a", "b", "c", "d"]

all_cidrs = flatten([var.public_cidrs, var.private_cidrs])
```

### `distinct(list)`
Removes duplicate values from a list.
```hcl
distinct(["a", "b", "a", "c", "b"])
# Result: ["a", "b", "c"]

unique_regions = distinct(var.regions)
```

### `slice(list, start, end)`
Extracts a portion of a list.
```hcl
slice(["a", "b", "c", "d"], 1, 3)
# Result: ["b", "c"]

first_three_azs = slice(var.availability_zones, 0, 3)
```

### `chunklist(list, size)`
Splits a list into fixed-size chunks.
```hcl
chunklist(["a", "b", "c", "d", "e"], 2)
# Result: [["a", "b"], ["c", "d"], ["e"]]

subnet_groups = chunklist(var.subnet_cidrs, 3)
```

---

## Type Conversion Functions

### `toset(list)` / `tolist(set)`
Converts between lists and sets (sets remove duplicates).
```hcl
toset(["a", "b", "a", "c"])   # Result: {"a", "b", "c"} (set)
tolist(toset(["a", "b", "a"])) # Result: ["a", "b", "c"] (list)

unique_tags = toset(var.tag_list)
```

### `tomap(object)` / `tonumber(string)` / `tostring(value)`
Type conversions.
```hcl
tonumber("42")          # Result: 42
tostring(42)            # Result: "42"
tomap({a = 1, b = 2})   # Ensures map type

port = tonumber(var.port_string)
```

---

## Numeric Functions

### `min(numbers...)` / `max(numbers...)`
Returns the smallest or largest number.
```hcl
min(5, 12, 3, 9)   # Result: 3
max(5, 12, 3, 9)   # Result: 12

count = min(length(var.azs), length(var.subnets))
```

### `ceil(number)` / `floor(number)`
Rounds up or down to the nearest integer.
```hcl
ceil(4.3)    # Result: 5
floor(4.7)   # Result: 4

instances = ceil(var.desired_capacity / var.instance_capacity)
```

### `abs(number)`
Returns absolute value.
```hcl
abs(-42)   # Result: 42
abs(42)    # Result: 42
```

---

## Encoding Functions

### `jsonencode(value)` / `jsondecode(string)`
Converts to/from JSON.
```hcl
jsonencode({name = "example", value = 42})
# Result: '{"name":"example","value":42}'

policy = jsonencode({
  Version = "2012-10-17"
  Statement = [{
    Effect = "Allow"
    Action = "s3:GetObject"
    Resource = "*"
  }]
})
```

### `base64encode(string)` / `base64decode(string)`
Encodes/decodes base64.
```hcl
base64encode("hello")  # Result: "aGVsbG8="
base64decode("aGVsbG8=")  # Result: "hello"

user_data = base64encode(file("init-script.sh"))
```

### `yamlencode(value)` / `yamldecode(string)`
Converts to/from YAML.
```hcl
yamlencode({name = "example", value = 42})
# Result: "name: example\nvalue: 42\n"

config = yamldecode(file("config.yaml"))
```

---

## File Functions

### `file(path)`
Reads a file's contents as a string.
```hcl
file("${path.module}/init-script.sh")

user_data = file("user-data.sh")
public_key = file("~/.ssh/id_rsa.pub")
```

### `fileexists(path)`
Checks if a file exists.
```hcl
fileexists("config.yaml")  # Result: true or false

use_custom_config = fileexists("custom-config.yaml")
```

### `templatefile(path, vars)`
Renders a template file with variables.
```hcl
# template.tpl:
# Hello, ${name}! Environment: ${env}

templatefile("template.tpl", {
  name = "World"
  env  = var.environment
})
# Result: "Hello, World! Environment: dev"

user_data = templatefile("init-script.sh.tpl", {
  db_host = aws_db_instance.main.endpoint
  app_port = var.app_port
})
```

---

## Date and Time Functions

### `timestamp()`
Returns the current timestamp in RFC 3339 format.
```hcl
timestamp()  # Result: "2024-01-10T15:30:00Z"

tags = {
  CreatedAt = timestamp()
}
```

### `formatdate(format, timestamp)`
Formats a timestamp.
```hcl
formatdate("YYYY-MM-DD", timestamp())
# Result: "2024-01-10"

formatdate("hh:mm:ss", timestamp())
# Result: "15:30:00"
```

---

## Conditional Functions

### `coalesce(values...)`
Returns the first non-null/non-empty value.
```hcl
coalesce("", "", "first", "second")  # Result: "first"
coalesce(null, "", "default")         # Result: "default"

name = coalesce(var.custom_name, var.default_name, "fallback")
```

### `coalescelist(lists...)`
Returns the first non-empty list.
```hcl
coalescelist([], ["a", "b"], ["c"])  # Result: ["a", "b"]

zones = coalescelist(var.custom_azs, data.aws_availability_zones.available.names)
```

### `try(expression, ...)`
Evaluates expressions in order, returning the first successful result.
```hcl
try(var.optional_value, "default")
# Returns var.optional_value if it exists, otherwise "default"

instance_type = try(var.instance_types[var.environment], "t3.micro")
```

---

## IP Network Functions

### `cidrsubnet(prefix, newbits, netnum)`
Calculates a subnet CIDR within a given CIDR block.
```hcl
cidrsubnet("10.0.0.0/16", 8, 0)   # Result: "10.0.0.0/24"
cidrsubnet("10.0.0.0/16", 8, 1)   # Result: "10.0.1.0/24"
cidrsubnet("10.0.0.0/16", 8, 2)   # Result: "10.0.2.0/24"

# Common pattern: create multiple subnets
resource "aws_subnet" "main" {
  count      = 3
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  # Creates 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24
}
```

### `cidrhost(prefix, hostnum)`
Calculates an IP address within a CIDR block.
```hcl
cidrhost("10.0.0.0/24", 5)    # Result: "10.0.0.5"
cidrhost("10.0.0.0/24", 100)  # Result: "10.0.0.100"

gateway_ip = cidrhost(aws_subnet.main.cidr_block, 1)
```

---

## Useful Patterns

### Dynamic resource naming
```hcl
resource "aws_s3_bucket" "app" {
  bucket = lower(join("-", [var.company, var.environment, var.region, "app-data"]))
  # Result: "acme-dev-us-east-1-app-data"
}
```

### Safe map lookups
```hcl
instance_type = lookup(var.instance_types, var.environment, "t3.micro")
# Returns "t3.micro" if var.environment key doesn't exist
```

### Removing duplicates
```hcl
locals {
  unique_tags = distinct(concat(var.common_tags, var.app_tags))
}
```

### Conditional subnet creation
```hcl
count = min(length(var.availability_zones), var.max_subnets)
# Creates subnets limited by available AZs or max_subnets, whichever is smaller
```

### Template rendering
```hcl
user_data = base64encode(templatefile("init.sh.tpl", {
  region     = var.region
  db_host    = aws_db_instance.main.endpoint
  app_config = jsonencode(var.app_config)
}))
```

---

## Best Practices

1. **Use `try()` for optional values** instead of complex conditionals
2. **Prefer `lookup()` with defaults** over checking if keys exist
3. **Use `coalesce()` for fallback values** in a clean, readable way
4. **Use `cidrsubnet()` for subnet calculations** instead of hardcoding CIDRs
5. **Use `templatefile()` for complex user data** instead of string concatenation
6. **Use `merge()` for combining tag maps** to keep tag management centralized
7. **Use `distinct()` and `toset()`** to ensure uniqueness in lists

---

For the complete list of built-in functions, see the [Terraform Functions Documentation](https://developer.hashicorp.com/terraform/language/functions).
