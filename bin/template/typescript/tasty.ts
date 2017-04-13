//===============================================================
// tasty

var burger: string = 'hamburger',     // String
    calories: number = 300,           // Numeric
    tasty: boolean = true;            // Boolean

// Alternatively, you can omit the type declaration:
// var burger = 'hamburger';

// The function expects a string and an integer.
// It doesn't return anything so the type of the function itself is void.

function speak(food: string, energy: number): void {
  console.log("Our " + food + " has " + energy + " calories.");
}

speak(burger, calories);

// The given type is boolean, the provided value is a string.
//ERR var tasty: boolean = "I haven't tried it yet";

// Arguments don't match the function parameters.
//ERR speak("tripple cheesburger", "a ton of");
