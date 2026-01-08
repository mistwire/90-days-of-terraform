/*
Hands on exercise https://ibm-learning.udemy.com/course/learn-how-to-code/learn/lecture/37688970#overview

This program demonstrates Go's switch statement with boolean expressions.
Key concepts covered:
- Random number generation
- Printf with format verbs
- Switch statements without an expression (expression-less switch)
- Case evaluation order and fall-through behavior
*/

// Package Declaration
// Every Go program starts with a package declaration
// "main" is a special package name that tells Go this is an executable program (not a library)
// Only the main package can be compiled into an executable binary
package main

// Import Block
// Imports external packages that provide additional functionality
// Go's standard library is extensive and well-documented at https://pkg.go.dev/std
import (
	// fmt package provides formatted I/O functions (print, scan, etc.)
	// Similar to C's stdio.h or Python's print function
	"fmt"
	// math/rand provides pseudo-random number generation
	// Note: For cryptographic purposes, use crypto/rand instead
	"math/rand"
)

// Main Function
// Entry point for Go programs - execution always starts here
// Syntax: func name(parameters) returnType { body }
// main() takes no parameters and returns nothing
func main() {
	// Variable Declaration with Short Assignment (:=)
	// := is the "short variable declaration" operator
	// It declares AND initializes a variable in one line
	// Go infers the type automatically (type inference)
	// Here, x is inferred as type int because rand.Intn() returns int
	//
	// rand.Intn(n) returns a random integer in the range [0, n)
	// [0, n) means: 0 to n-1 inclusive (0 is included, n is excluded)
	// So rand.Intn(300) returns values from 0 to 299
	x := rand.Intn(300)

	// Printf - Formatted Print Function
	// Printf uses format verbs (placeholders) to control output formatting
	// %v is the "default format" verb - it prints the value in its natural format
	// \n is the newline character (moves to next line after printing)
	//
	// Other common format verbs:
	// %d - decimal integer
	// %s - string
	// %T - type of the value
	// %t - boolean
	fmt.Printf("The value of x is %v\n", x)

	// Switch Statement (Expression-less Switch)
	// This is a "tagless switch" or "expression-less switch"
	// Syntax: switch { case condition: ... }
	// When there's no expression after "switch", it's equivalent to "switch true"
	// Each case contains a boolean expression that's evaluated in order
	//
	// How it works:
	// 1. Go evaluates each case condition top-to-bottom until one is true
	// 2. When a case matches, its code runs and the switch AUTOMATICALLY exits
	// 3. No "break" needed! (Unlike C/Java where you need explicit break statements)
	// 4. If no cases match, the default case runs (if present)
	//
	// This pattern is particularly useful when you have multiple different conditions
	// to check (not just comparing one value against many possibilities)
	switch {
	// Case 1: Checks if x is 100 or less
	// The order matters! This runs first, so values 0-100 are caught here
	case x <= 100:
		fmt.Println("less than 100")

	// Case 2: Checks if x is 200 or less
	// Only evaluated if previous case was false
	// So this catches values 101-200 (100 was already handled above)
	case x <= 200:
		fmt.Println("between 101 and 200")

	// Case 3: Checks if x is 250 or less
	// Catches values 201-250
	case x <= 250:
		fmt.Println("between 201 and 250")

	// Default Case: Runs when no other case matches
	// This is optional, but good practice for handling all possibilities
	// Catches values 251-299 in our example
	default:
		fmt.Println("more than 250")
	}

	// Note: Go's switch is different from C/Java/JavaScript:
	// - No automatic fall-through (no need for break statements)
	// - Can switch on any comparable type (not just integers)
	// - Can use expressions in cases (not just constants)
	// - Can have expression-less switches like this one
	// - If you DO want fall-through, use the "fallthrough" keyword explicitly
}