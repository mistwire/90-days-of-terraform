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
**Directory:** [`01/`](01/)
**Concepts covered:**
- Terraform, Provider, Variable, Data, Resource, and Output blocks
- CIDR notation and VPC networking fundamentals
- The `~>` pessimistic constraint operator for provider versions
- Dot notation for resource references and implicit dependencies
- String interpolation with `${...}` syntax
- The splat operator `[*]` for accessing attributes from counted resources
- `cidrsubnet()` function for calculating subnet CIDR blocks

**Key takeaway:** Understanding the six core block types is the foundation for everything in Terraform.

---

#### Day 2: Data Sources and Network Structure
**Directory:** [`02/`](02/)
**Concepts covered:**
- Deep dive into AWS data sources (regions, AZs, caller identity)
- VPC structure with DNS settings
- Private subnets and their characteristics
- Route tables and traffic flow fundamentals
- Tagging strategies for organization and cost tracking

**Key takeaway:** Data sources are read-only queries that fetch existing infrastructure information—essential for making configurations dynamic and aware of their environment.

---

#### Day 3: Locals and the merge() Function
**Directory:** [`03/`](03/)
**Concepts covered:**
- Local values for DRY principle and computed values
- `merge()` function for combining maps
- Difference between locals and variables
- Public vs private subnets (`map_public_ip_on_launch`)
- Security groups as virtual firewalls (stateful, default-deny)
- Ingress and egress rules (inbound/outbound traffic)

**Key takeaway:** Locals compose values from multiple sources and reduce repetition. Use `merge(local.tags, {...})` to consistently apply base tags while adding resource-specific ones.

---

#### Day 4: The count Meta-Argument
**Directory:** [`04/`](04/)
**Concepts covered:**
- `count` meta-argument for creating multiple resource instances
- `count.index` for accessing the current iteration (0-based)
- Using count with list variables for parallel configuration
- Using count with `list(object())` for complex configurations
- Resource referencing with bracket notation: `resource[index]`

**Key takeaway:** Count enables DRY infrastructure—define once, create many. Access instances with bracket notation and use `count.index` to customize each instance.

---

#### Day 5: Go Fundamentals - Switch Statements
**Directory:** [`05/`](05/)
**Language:** Go
**Concepts covered:**
- Package declaration (`package main` for executables)
- Import statements and Go standard library
- Short variable declaration (`:=`) with type inference
- `rand.Intn()` for random number generation
- `Printf` with format verbs (`%v`, `%d`, `%s`, `%T`, `%t`)
- Expression-less switch statements (`switch { case condition: ... }`)
- Case evaluation order and automatic break behavior
- How Go's switch differs from C/Java/JavaScript

**Key takeaway:** Go's expression-less switch is powerful for evaluating multiple different boolean conditions. Unlike other languages, it automatically exits after a match—no explicit `break` needed.

---

### Week 1 Progress: 🟡 In Progress (5/7 days complete)

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
