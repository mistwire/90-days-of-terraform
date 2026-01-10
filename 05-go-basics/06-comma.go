/*
If Statement with Initialization (Comma-OK Idiom Pattern)

This program demonstrates:
- If statements with initialization syntax
- Variable scope limited to if/else blocks
- The "comma-ok" idiom pattern (common in Go)
- Why this pattern is useful for clean, safe code
*/

package main

import (
	"fmt"
	"math/rand"
)

/*
From the Go Language Specification:
"The expression [evaluated in an if statement] may be preceded by a simple statement,
which executes before the expression is evaluated."

Syntax: if initialization; condition { ... }
*/
// https://go.dev/ref/spec#If_statements

/*
This pattern is also known as the "comma-ok idiom" in Go
It's used throughout Go's standard library, especially for:
- Map lookups: if value, ok := myMap[key]; ok { ... }
- Type assertions: if val, ok := x.(string); ok { ... }
- Channel receives: if msg, ok := <-ch; ok { ... }
*/
// https://go.dev/play/p/OXGzjxVkag0

func main() {
	// SEQUENCE
	x := 40

	// If Statement with Initialization
	// Syntax: if initialization; condition { ... }
	//
	// Here's what happens:
	// 1. z := 2 * rand.Intn(x)  - Initialize z (executes once)
	// 2. z >= x                  - Evaluate the condition
	// 3. If true, run if block; if false, run else block
	//
	// Why use this pattern?
	// 1. Limits scope: z only exists within this if/else block
	// 2. Cleaner code: declaration and check happen together
	// 3. Prevents accidental reuse: z can't be used after this block
	// 4. More readable: the intent is clear and contained
	if z := 2 * rand.Intn(x); z >= x {
		// z is accessible here in the if block
		fmt.Printf("z is %v and that is GREATER THAN OR EQUAL x which is %v\n", z, x)
	} else {
		// z is also accessible here in the else block
		fmt.Printf("z is %v and that is LESS THAN x which is %v\n", z, x)
	} // The scope of z ends here - it no longer exists after this closing brace

	// If you tried to use z here, you'd get a compile error:
	// "undefined: z"
	// This is a GOOD thing - it prevents bugs from accidentally using
	// temporary variables outside their intended scope

	// Real-World Example: Map Lookup with Comma-OK Idiom
	// ages := map[string]int{"Alice": 30, "Bob": 25}
	// if age, ok := ages["Alice"]; ok {
	//     fmt.Printf("Alice is %d years old\n", age)
	// } else {
	//     fmt.Println("Alice not found")
	// }
	//
	// This pattern is so common in Go that it's called an "idiom"
	// "ok" is a convention for the boolean that indicates success/presence
}
