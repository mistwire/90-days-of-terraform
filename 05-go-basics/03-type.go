/*
Type Inference and Type Conversion in Go

This program demonstrates:
- Go's static typing system
- Type inference with := operator
- The %T format verb for printing types
- Type conversion (explicit, not implicit)
- Why Go doesn't allow automatic type conversion
*/

package main

import (
	"fmt"
)

func main() {
	// Type Inference
	// Go is statically typed (every variable has a fixed type)
	// But the := operator infers the type from the value
	//
	// When you write an integer literal (42), Go infers it as int
	// When you write a decimal literal (42.0), Go infers it as float64
	y := 42   // Type: int
	z := 42.0 // Type: float64 (Go's default floating-point type)

	// %T Format Verb - Prints the Type
	// %v prints the value, %T prints the type
	// This is extremely useful for debugging and understanding your code
	fmt.Printf("%v of type %T \n", y, y) // Output: 42 of type int
	fmt.Printf("%v of type %T \n", z, z) // Output: 42 of type float64

	// Explicit Type Declaration
	// Sometimes you want a specific type, not Go's default inference
	// Here we explicitly declare m as float32 (instead of default float64)
	// Why? float32 uses less memory (4 bytes vs 8 bytes)
	// Trade-off: less precision, smaller range, but more memory-efficient
	var m float32 = 43.742
	fmt.Printf("%v of type %T \n", m, m) // Output: 43.742 of type float32

	// Type Conversion is Explicit in Go (NOT implicit)
	// This is a KEY difference from languages like C, Python, JavaScript
	//
	// This WILL NOT WORK (see commented code):
	// Go doesn't allow assigning float32 to float64 automatically
	// Even though both are floating-point numbers, they're different types
	/*
		// this does not work!
		// in go you can't take a VALUE that is float32 and store it
		// in a variable that is declared to hold a VALUE of float64
		z = m
		fmt.Printf("%v of type %T \n", z, z)
	*/

	// To convert between types, you MUST explicitly convert
	// Syntax: newType(value)
	// This is called "type conversion" or "casting"
	// float64(m) converts the float32 value in m to float64
	z = float64(m)                       // Explicit conversion required
	fmt.Printf("%v of type %T \n", z, z) // Now z holds m's value as float64

	// Why Go requires explicit conversion:
	// 1. Prevents accidental data loss (e.g., float to int loses decimal)
	// 2. Makes conversions visible and intentional
	// 3. Catches bugs at compile time instead of runtime
	// 4. Makes code more readable - you see exactly where conversions happen
	//
	// Reference: https://go.dev/ref/spec#Conversions
}
