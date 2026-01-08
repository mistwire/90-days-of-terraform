/*
Comparison and Logical Operators in Go

This program demonstrates:
- The init() function (runs before main)
- Comparison operators (==, !=, <, <=, >, >=)
- Logical operators (&&, ||, !)
- Short-circuit evaluation (efficient boolean logic)
- Combining multiple conditions in if statements
*/

package main

import (
	"fmt"
)

// init() Function
// Special function that runs automatically BEFORE main()
// Used for initialization tasks, setup, configuration
// You can have multiple init() functions in a package (they run in order)
// Common uses: setting up databases, loading config, initializing variables
func init() {
	fmt.Println("init func runs before main")
}

func main() {
	// SEQUENCE - Demonstrating Execution Order
	fmt.Println("this is the first func main statement to run")
	fmt.Println("this is the second statement to run")
	x := 40 // this is the third statement to run
	y := 5  // this is the fourth statement to run
	fmt.Printf(" x=%v \n y=%v\n", x, y)

	// COMPARISON OPERATORS
	// Compare two values and return a boolean (true or false)
	// These are the building blocks of conditional logic
	/*
		==    equal             (x == 42 means "is x equal to 42?")
		!=    not equal         (x != 42 means "is x not equal to 42?")
		<     less              (x < 42 means "is x less than 42?")
		<=    less or equal     (x <= 42 means "is x less than or equal to 42?")
		>     greater           (x > 42 means "is x greater than 42?")
		>=    greater or equal  (x >= 42 means "is x greater than or equal to 42?")
	*/
	// https://go.dev/ref/spec#Comparison_operators

	// LOGICAL OPERATORS
	// Combine multiple boolean expressions into one
	// Allow you to check multiple conditions at once

	// AND Operator (&&)
	// Both conditions must be true for the entire expression to be true
	// "p && q" means: "if p is true, then check q, else return false"
	// This is "short-circuit" evaluation: if p is false, q is never evaluated
	if x < 42 && y < 42 {
		fmt.Println("both are less than the meaning of life")
	}
	// x=40 (< 42 is true) AND y=5 (< 42 is true) = both true, so this prints

	// OR Operator (||)
	// At least ONE condition must be true for the entire expression to be true
	// "p || q" means: "if p is true, return true, else check q"
	// This is also "short-circuit": if p is true, q is never evaluated
	if x > 30 || x < 42 {
		fmt.Println("x is getting close to the meaning of life")
	}
	// x=40 (> 30 is true) so the first condition is true
	// Because of short-circuit evaluation, "x < 42" doesn't even get checked
	// At least one is true, so this prints

	// NOT EQUAL Operator (!=)
	// Checks if two values are different (opposite of ==)
	if x != 42 {
		fmt.Println("x is not 42")
	}
	// x=40, which is not equal to 42, so this is true and prints

	// Summary of Logical Operators:
	/*
		&&    conditional AND    p && q  is  "if p then q else false"
		||    conditional OR     p || q  is  "if p then true else q"
		!     NOT                !p      is  "not p"
	*/
	// https://go.dev/ref/spec#Logical_operators

	// Short-Circuit Evaluation Benefits:
	// 1. Performance: doesn't evaluate unnecessary expressions
	// 2. Safety: prevents errors (e.g., "if x != nil && x.value > 0")
	//    If x is nil, the second part never runs, avoiding a panic

	// Truth Tables for Reference:
	// AND (&&): true && true = true, all other combinations = false
	// OR (||):  false || false = false, all other combinations = true
	// NOT (!):  !true = false, !false = true
}
