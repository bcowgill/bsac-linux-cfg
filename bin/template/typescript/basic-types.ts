//===============================================================
// basic-types

let isDone: boolean = false;

let decimal: number = 6;
let hex: number = 0xf00d;
let binary: number = 0b1010;
let octal: number = 0o744;

let color: string = "blue";
color = 'red';

let fullName: string = `Bob Bobbington`;
let age: number = 37;
let sentence: string = `Hello, my name is ${ fullName }.

I'll be ${ age + 1 } years old next month.`;

let sentence2: string = "Hello, my name is " + fullName + ".\n\n" +
"I'll be " + (age + 1) + " years old next month.";

let list: number[] = [1, 2, 3];
let list2: Array<number> = [1, 2, 3];

// Declare a tuple type
let x: [string, number];
// Initialize it
x = ["hello", 10]; // OK
// Initialize it incorrectly
//ERR x = [10, "hello"]; // Error

console.log(x[0].substr(1)); // OK
//ERR console.log(x[1].substr(1)); // Error, 'number' does not have 'substr'

x[3] = "world"; // OK, 'string' can be assigned to 'string | number'

console.log(x[5].toString()); // OK, 'string' and 'number' both have 'toString'

//ERR x[6] = true; // Error, 'boolean' isn't 'string | number'

// Declare enumerations
enum Color {Red, Green, Blue}
let c: Color = Color.Green;

enum Color1 {Red = 1, Green, Blue}
let c1: Color1 = Color1.Green;

enum Color2 {Red = 1, Green = 2, Blue = 4}
let c2: Color2 = Color2.Green;

enum Color3 {Red = 1, Green, Blue}
let colorName: string = Color3[2];

alert(colorName);


let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false; // okay, definitely a boolean

let notSure2: any = 4;
notSure2.ifItExists(); // okay, ifItExists might exist at runtime
notSure2.toFixed(); // okay, toFixed exists (but the compiler doesn't check)

let prettySure: Object = 4;
//ERR prettySure.toFixed(); // Error: Property 'toFixed' doesn't exist on type 'Object'.

let list3: any[] = [1, true, "free"];

list3[1] = 100;

function warnUser(): void {
    alert("This is my warning message");
}

let unusable: void = undefined;

// Not much else we can assign to these variables!
let u: undefined = undefined;
let n: null = null;

// Function returning never must have unreachable end point
function error2(message: string): never {
    throw new Error(message);
}

// Inferred return type is never
function fail2() {
    return error2("Something failed");
}

// Function returning never must have unreachable end point
function infiniteLoop2(): never {
    while (true) {
    }
}

// Type assertions
let someValue: any = "this is a string";

let strLength: number = (<string>someValue).length;

let someValue2: any = "this is a string";

let strLength2: number = (someValue2 as string).length;


