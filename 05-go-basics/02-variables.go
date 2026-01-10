/*
Variable Declaration Patterns in Go

This program demonstrates the different ways to declare and initialize variables:
1. Short declaration operator (:=) - most common, type inferred
2. Multiple assignment with the blank identifier (_)
3. var keyword with zero value initialization
4. var keyword with explicit type and value
*/

package main

import "fmt"

func main() {
	// Short Declaration Operator (:=)
	// This is the most common way to declare variables inside functions
	// Syntax: name := value
	// Go automatically infers the type from the value (type inference)
	// Here, 'a' is inferred as type int
	a := 42
	fmt.Println(a)

	// Multiple Assignment
	// Go allows declaring multiple variables in one line
	// All variables on the left are assigned values from the right, in order
	// The blank identifier (_) is used to ignore values you don't need
	//
	// Why use _? Because Go requires all declared variables to be used
	// If you don't need a value, assign it to _ to tell Go "I'm ignoring this intentionally"
	// Here: b=0, c=1, d=2, the value 3 is ignored, f="happiness"
	b, c, d, _, f := 0, 1, 2, 3, "happiness"
	fmt.Println(b, c, d, f) // Note: we don't print the ignored value

	// Why This Wouldn't Work (see commented code below):
	// If we declared b, c, d, e using := and didn't use 'e' later in the code,
	// Go would give a compilation error: "e declared but not used"
	// Go is strict about unused variables to prevent bugs and keep code clean
	/*
		b, c, d, e := 0, 1, 2, 3
		fmt.Println(b, c, d)
	*/

	// Variable Declaration with var (Zero Value)
	// var keyword can be used for declaration without immediate initialization
	// When you don't provide a value, Go assigns a "zero value":
	// - int: 0
	// - string: ""
	// - bool: false
	// - pointer: nil
	var g int
	fmt.Println(g) // Prints 0 (the zero value for int)
	// Later, we can assign a value to g
	g = 43
	fmt.Println(g) // Now prints 43

	// Variable Declaration with var (Explicit Type and Value)
	// You can also declare with var and provide both type and value
	// Syntax: var name type = value
	// This is more verbose than := but useful when you want to be explicit
	// about the type, especially for package-level variables
	var h int = 44
	fmt.Println(h)

	// Summary of Declaration Styles:
	// := - Quick, inside functions only, type inferred
	// var name type - Declare without initializing, gets zero value
	// var name type = value - Explicit type and value, more verbose
	//
	// Most common: Use := inside functions unless you need a specific zero value
}
