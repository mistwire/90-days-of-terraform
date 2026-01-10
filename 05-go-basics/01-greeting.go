/*
User Input and Error Handling in Go

This program demonstrates:
- Reading user input from the console
- Multiple return values (Go functions can return multiple values)
- Error handling with if/else
- The nil keyword (Go's version of null)
- Pointers with the & operator (passing by reference)
*/

package main

import (
	"fmt"
)

func main() {
	// Variable Declaration with var keyword
	// Unlike := (short declaration), var can be used at package level
	// Here we declare variables but don't initialize them yet
	// Go gives them "zero values": "" for strings, 0 for ints
	var name string
	var age int

	// fmt.Print() outputs text without a newline at the end
	// This keeps the cursor on the same line, waiting for user input
	fmt.Print("Enter your name and age: ")

	// fmt.Scanln() reads input from the console
	// Key concepts:
	// 1. Multiple return values: n (number of items scanned) and err (error if any)
	// 2. & operator creates a pointer (passes the variable's memory address)
	//    This allows Scanln to modify the actual variables, not copies
	// 3. Scanln expects inputs separated by spaces, ends at newline
	n, err := fmt.Scanln(&name, &age)

	// Error Handling Pattern
	// In Go, errors are values (not exceptions like in Java/Python)
	// nil means "no value" or "no error" (similar to null in other languages)
	// The pattern "if err != nil" is extremely common in Go
	if err != nil {
		// If there was an error reading input, print it
		// Examples: wrong data type, EOF, unexpected format
		fmt.Println("Error:", err)
	} else {
		// If no error (err == nil), print what we successfully scanned
		// %d format verb is for integers (decimal)
		// %s format verb is for strings
		// n tells us how many items were successfully scanned
		fmt.Printf("Scanned %d items. Name: %s, Age: %d\n", n, name, age)
	}

	// Key Go patterns demonstrated:
	// 1. Multiple return values (especially for error handling)
	// 2. Error as a value (not exception throwing)
	// 3. Explicit error checking (if err != nil)
	// 4. Pointers for passing by reference (&variable)
}
