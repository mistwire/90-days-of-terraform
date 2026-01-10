/*
Conditional Logic with If Statements in Go

This program demonstrates:
- Sequential execution (statements run in order)
- If statements (single condition)
- If-else statements (two branches)
- If-else if-else statements (multiple conditions)
- How Go evaluates boolean expressions
*/

package main

import (
	"fmt"
)

func main() {
	// SEQUENCE - Code Runs Top to Bottom
	// By default, programs execute one statement at a time, in order
	// This is called "sequential execution" or "control flow"
	x := 42 // First: declare and initialize x
	y := 5  // Second: declare and initialize y
	fmt.Printf(" x=%v \n y=%v\n", x, y) // Third: print both values

	// CONDITIONAL EXECUTION
	// Conditionals let code "branch" - execute different statements based on conditions
	// Two main types in Go:
	// 1. if statements (covered here)
	// 2. switch statements (covered in 01-switch.go)

	// Simple If Statement (no else)
	// Syntax: if condition { code }
	// If condition is true, the code block executes
	// If condition is false, nothing happens (execution continues after the block)
	if x < 42 {
		fmt.Println("Less than the meaning of life")
	}
	// In this case, x == 42, so the condition is false and nothing prints

	// If-Else Statement (two branches)
	// Syntax: if condition { code } else { code }
	// Exactly ONE of the two branches will execute
	// This ensures you handle both true and false cases
	if x < 42 {
		fmt.Println("Less than the meaning of life")
	} else {
		fmt.Println("equal to, or greater than, the meaning of life")
	}
	// x == 42, so the else branch executes

	// If-Else If-Else (multiple conditions)
	// Syntax: if condition1 { } else if condition2 { } else { }
	// Go evaluates conditions top-to-bottom and executes the FIRST true branch
	// The else at the end is a "catch-all" for when no conditions match
	if x < 42 {
		fmt.Println("Less than the meaning of life")
	} else if x == 42 {
		fmt.Println("equal to the meaning of life")
	} else {
		fmt.Println("greater than the meaning of life")
	}
	// x == 42, so the middle branch (else if) executes

	// Key Points:
	// - Conditions must be boolean expressions (true or false)
	// - Only ONE branch executes (unlike some other control structures)
	// - else and else if are optional
	// - No parentheses required around conditions (unlike C/Java)
	// - Braces { } are always required (unlike Python)

	/*
		From the Go Language Specification:
		"If" statements specify the conditional execution of two branches
		according to the value of a boolean expression. If the expression evaluates
		to true, the "if" branch is executed, otherwise, if present, the "else" branch is executed.
	*/
	// https://go.dev/ref/spec#If_statements
}
