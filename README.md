# 90 Days of Terraform & Go

---

## 🎯 The Mission

Learning Terraform and Go from the ground up—documented publicly for my future self.

This repository tracks 90 learning sessions focused on two interconnected goals:
1. **Terraform mastery**: Building production-ready infrastructure as code skills
2. **Go fundamentals**: Learning the language to eventually create custom Terraform providers

Why both? Terraform providers are written in Go. By learning them together, I'm building toward the ability to extend Terraform with custom providers when existing ones don't meet my needs.

## 📚 Learning Philosophy

**Starting from zero** - Complete beginner in both Terraform and Go
**Learn in public** - Documenting for future reference and potential value to others
**Comprehensive comments** - Every code example includes detailed explanatory remarks
**Hands-on focus** - Building real examples, not just theory

---

## 📊 Daily Learning Log

### Week 1: Foundations (January 6-12, 2025)

#### Day 1: Terraform Basics - Core Blocks
**Directory:** [`01-terraform-basics/`](01-terraform-basics/)
**Concepts covered:**
- Terraform, Provider, Variable, Data, Resource, and Output blocks
- CIDR notation and VPC networking fundamentals
- The `~>` pessimistic constraint operator for provider versions
- Dot notation for resource references and implicit dependencies
- String interpolation with `${...}` syntax
- The splat operator `[*]` for accessing attributes from counted resources
- `cidrsubnet()` function for calculating subnet CIDR blocks

---

#### Day 2: Data Sources and Network Structure
**Directory:** [`02-data-sources/`](02-data-sources/)
**Concepts covered:**
- Deep dive into AWS data sources (regions, AZs, caller identity)
- VPC structure with DNS settings
- Private subnets and their characteristics
- Route tables and traffic flow fundamentals
- Tagging strategies for organization and cost tracking

---

#### Day 3: Locals and the merge() Function
**Directory:** [`03-locals/`](03-locals/)
**Concepts covered:**
- Local values for DRY principle and computed values
- `merge()` function for combining maps
- Difference between locals and variables
- Public vs private subnets (`map_public_ip_on_launch`)
- Security groups as virtual firewalls (stateful, default-deny)
- Ingress and egress rules (inbound/outbound traffic)

---

#### Day 4: The count Meta-Argument
**Directory:** [`04-count/`](04-count/)
**Concepts covered:**
- `count` meta-argument for creating multiple resource instances
- `count.index` for accessing the current iteration (0-based)
- Using count with list variables for parallel configuration
- Using count with `list(object())` for complex configurations
- Resource referencing with bracket notation: `resource[index]`

---

#### Day 5: Go Fundamentals - Control Flow & Types
**Directory:** [`05-go-basics/`](05-go-basics/)
**Language:** Go
**Concepts covered:**
- User input with `fmt.Scanln()`, multiple return values, error handling (`if err != nil`)
- Variable declaration patterns (`:=`, `var`, blank identifier `_`, zero values)
- Type inference and explicit type conversion (no implicit casting)
- Expression-less switch statements and if/else conditionals
- Comparison operators (`==`, `!=`, `<`, `>`) and logical operators (`&&`, `||`, `!`)
- The `init()` function and short-circuit evaluation
- If statement with initialization (comma-ok idiom), scoped variables

---

#### Day 6: The for_each Meta-Argument
**Directory:** [`06-tf-for-each/`](06-tf-for-each/)
**Concepts covered:**
- `for_each` meta-argument for creating multiple resource instances from maps or sets
- Difference between `count` (list-based, index-driven) and `for_each` (map/set-based, key-driven)
- `each.key` and `each.value` for accessing current iteration values
- Advantages of `for_each`: stable resource addresses that don't shift when items are added/removed
- Resource referencing with map notation: `resource[key]`
- Combining `for_each` with map variables for more maintainable infrastructure
- The danger of `count` with list reordering (can cause unwanted resource recreation)

---

#### Day 7: Advanced Resource Management
**Directory:** [`07-multiple/`](07-multiple/) with 4 sub-topics

**01-depends-on: Resource Dependencies**
- Implicit dependencies (automatic when referencing resource attributes)
- Explicit dependencies using the `depends_on` meta-argument
- Dependency chains for sequential operations

**02-multi-providers: Multiple Provider Configurations**
- Using `alias` to create multiple configurations of the same provider
- Multi-region deployments with `provider = aws.alias_name`
- Useful for disaster recovery, geographic distribution, multi-account setups

**03-lifecycle: Lifecycle Meta-Arguments**
- `prevent_destroy`: blocks resource deletion (protection for critical resources)
- `create_before_destroy`: creates replacement before destroying (zero-downtime updates)
- `ignore_changes`: prevents Terraform from reverting external changes

**04-built-ins: Built-in Functions**
- String functions: `join()`, `split()`, `format()`, `lower()`, `upper()`, `replace()`
- Collection functions: `length()`, `concat()`, `merge()`, `lookup()`, `contains()`, `flatten()`, `distinct()`
- Type conversions: `toset()`, `tolist()`, `tonumber()`, `tostring()`
- Numeric: `min()`, `max()`, `ceil()`, `floor()`
- Encoding: `jsonencode()`, `base64encode()`, `yamlencode()`
- IP network: `cidrsubnet()`, `cidrhost()`
- See [`04-built-ins/README.md`](07-multiple/04-built-ins/README.md) for comprehensive function reference

**Key takeaway:** Day 7 covers meta-arguments that modify resource behavior beyond basic configuration. Use `depends_on` for non-obvious ordering, `alias` for multi-region/account deployments, `lifecycle` blocks to control replacement behavior, and built-in functions to transform and manipulate data within your configurations.

---

### Week 1 Progress: 🎯 Complete! (7/7 days complete)

---

## 🎯 Learning Approach

**Terraform Focus (Primary)**
- Fundamentals: blocks, state, modules, functions
- AWS-focused examples (most common provider)
- Production patterns: tagging, naming, organization
- Advanced concepts: workspaces, remote state, modules

**Go Focus (Supporting)**
- Language fundamentals: syntax, types, control flow
- Standard library exploration
- Building toward understanding Terraform provider code
- Hands-on exercises from Udemy Go course

**Alternating Pattern:** Days mix between Terraform and Go to keep both skills progressing. Eventually, these converge when building custom providers.

---

## 📚 Resources

**Terraform:**
- [Terraform for Beginners with Labs](https://udemy.com/course/terraform-for-beginners-with-labs) by Bryan Krausen (Primary course)
- [HashiCorp Learn](https://developer.hashicorp.com/terraform/tutorials) (Official tutorials)
- [Terraform Documentation](https://www.terraform.io/docs) (Reference)
- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) (AWS-specific)

**Go:**
- [Learn How to Code: Google's Go (golang) Programming Language](https://www.udemy.com/course/learn-how-to-code/) (Primary course)
- [Go by Example](https://gobyexample.com/) (Quick reference)
- [Effective Go](https://go.dev/doc/effective_go) (Best practices)
- [A Tour of Go](https://go.dev/tour/) (Interactive tutorial)

**Terraform Provider Development:**
- [Terraform Plugin Framework](https://developer.hashicorp.com/terraform/plugin/framework) (When ready)
- [Plugin Development Tutorial](https://developer.hashicorp.com/terraform/tutorials/providers-plugin-framework) (Future reference)

---

## 💡 Notes for Future Self

**What's working:**
- Detailed inline comments make it easy to remember concepts later
- Alternating between Terraform and Go keeps learning fresh
- Building incrementally on previous days' concepts creates solid foundation

**Remember:**
- This is a flexible timeline—90 learning sessions, not necessarily consecutive days
- Every expert was once a beginner; progress over perfection
- The detailed comments might seem excessive now, but future-you will appreciate them

---

## 📊 Milestones

- [ ] Complete 30 days (1/3 of journey)
- [ ] Complete 60 days (2/3 of journey)
- [ ] Complete all 90 learning sessions
- [ ] Build first custom Terraform provider (stretch goal)
- [ ] Contribute to an existing Terraform provider (stretch goal)
