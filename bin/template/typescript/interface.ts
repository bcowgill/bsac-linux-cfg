//===============================================================
// interface

// Here we define our Food interface, its properties, and their types.
interface Food {
    name: string;
    calories: number;
}

// We tell our function to expect an object that fulfills the Food interface.
// This way we know that the properties we need will always be available.
function speak1(food: Food): void{
  console.log("Our " + food.name + " has " + food.calories + " calories.");
}

// We define an object that has all of the properties the Food interface expects.
// Notice that types will be inferred automatically.
var ice_cream = {
  name: "ice cream",
  calories: 200
}

speak1(ice_cream);

// We've made a deliberate mistake and name is misspelled as nmae.
var ice_cream2 = {
  nmae: "ice cream",
  calories: 200
}

//ERR speak1(ice_cream2);

// Simple inline interface

function printLabel(labelledObj: { label: string }) {
    console.log(labelledObj.label);
}

let myObj = {size: 10, label: "Size 10 Object"};
printLabel(myObj);

// Again with interface declared

interface LabelledValue {
    label: string;
}

function printLabel2(labelledObj: LabelledValue) {
    console.log(labelledObj.label);
}

let myObj2 = {size: 10, label: "Size 10 Object"};
printLabel2(myObj2);


// Optional parameters in interface
// And Excess property checks on them

interface SquareConfig {
    color?: string;
    width?: number;
}

function createSquare(config: SquareConfig): {color: string; area: number} {
    let newSquare = {color: "white", area: 100};
    if (config.color) {
        newSquare.color = config.color;
    }
    if (config.width) {
        newSquare.area = config.width * config.width;
    }
    return newSquare;
}

let mySquare = createSquare({color: "black"});

// Again with detected error

function createSquare2(config: SquareConfig): { color: string; area: number } {
    let newSquare = {color: "white", area: 100};
    if (config.color) {
        // Error: Property 'clor' does not exist on type 'SquareConfig'
//ERR        newSquare.color = config.clor;
    }
    if (config.width) {
        newSquare.area = config.width * config.width;
    }
    return newSquare;
}

let mySquare2 = createSquare2({color: "black"});

// Could argue this is correctly typed as color is optional but
// typescript calls this a bug as colour is probably really a typo
//ERR let mySquare3 = createSquare({ colour: "red", width: 100 });

// If you really mean it you can use a type assertion...
let mySquare4 = createSquare({ width: 100, opacity: 0.5 } as SquareConfig);

// Or just assign to another variable which won't undergo excess checks
let squareOptions = { colour: "red", width: 100 };
let mySquare5 = createSquare(squareOptions);

// But might be better to indicate that there can be additional properties present
interface SquareConfig2 {
    color?: string;
    width?: number;
    [propName: string]: any;
}

function createSquare3(config: SquareConfig2): {color: string; area: number} {
    let newSquare = {color: "white", area: 100};
    if (config.color) {
        newSquare.color = config.color;
    }
    if (config.width) {
        newSquare.area = config.width * config.width;
    }
    return newSquare;
}

let mySquare6 = createSquare3({ width: 100, opacity: 0.5 });

// Read only properties, arrays
// const for variables, readonly for properties

interface Point {
    readonly x: number;
    readonly y: number;
}

let p1: Point = { x: 10, y: 20 };
//ERR p1.x = 5; // error!


let a: number[] = [1, 2, 3, 4];
let ro: ReadonlyArray<number> = a;
//ERR ro[0] = 12; // error!
//ERR ro.push(5); // error!
//ERR ro.length = 100; // error!
//ERR a = ro; // error!

a = ro as number[];  // override read only with a type assertion


