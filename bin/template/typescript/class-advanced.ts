//===============================================================
// class static interfaces

class Grid {
    static origin = {x: 0, y: 0};
    calculateDistanceFromOrigin(point: {x: number; y: number;}) {
        let xDist = (point.x - Grid.origin.x);
        let yDist = (point.y - Grid.origin.y);
        return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
    }
    constructor (public scale: number) { }
}

let grid1 = new Grid(1.0);  // 1x scale
let grid2 = new Grid(5.0);  // 5x scale

console.log(grid1.calculateDistanceFromOrigin({x: 10, y: 10}));
console.log(grid2.calculateDistanceFromOrigin({x: 10, y: 10}));

// Abstract classes
abstract class Animal5 {
    abstract makeSound(): void;
    move(): void {
        console.log("roaming the earth...");
    }
}

abstract class Department {

    constructor(public name: string) {
    }

    printName(): void {
        console.log("Department name: " + this.name);
    }

    abstract printMeeting(): void; // must be implemented in derived classes
}

class AccountingDepartment extends Department {

    constructor() {
        super("Accounting and Auditing"); // constructors in derived classes must call super()
    }

    printMeeting(): void {
        console.log("The Accounting Department meets each Monday at 10am.");
    }

    generateReports(): void {
        console.log("Generating accounting reports...");
    }
}

let department: Department; // ok to create a reference to an abstract type
//ERR department = new Department(); // error: cannot create an instance of an abstract class
department = new AccountingDepartment(); // ok to create and assign a non-abstract subclass
department.printName();
department.printMeeting();
//ERR department.generateReports(); // error: method doesn't exist on declared abstract type

// The class constructor function under the hood.
class Greeter0 {
    static standardGreeting = "Hello, there";
    greeting: string;
    constructor (message: string) {
        this.greeting = message;
    }
    greet () {
        if (this.greeting) {
            return "Hello, " + this.greeting;
        }
        else {
            return Greeter0.standardGreeting;
        }
    }
    static message () {
      return Greeter0.standardGreeting;
    }
}

let greeter1: Greeter0;
greeter1 = new Greeter0("Hola!");
console.log(greeter1.greet());

let greeterMaker: typeof Greeter0 = Greeter0;
greeterMaker.standardGreeting = "Hey there!";

let greeter2: Greeter0 = new greeterMaker("Greetings, Earthling");
console.log(greeter2.greet());

// The declaration above generates a constructor function in javascript:
/*
var Greeter0 = (function () {
    function Greeter0(message) {
        this.greeting = message;
    }
    Greeter0.prototype.greet = function () {
        if (this.greeting) {
            return "Hello, " + this.greeting;
        }
        else {
            return Greeter0.standardGreeting;
        }
    };
    Greeter0.message = function () {
        return Greeter0.standardGreeting;
    };
    return Greeter0;
}());
Greeter0.standardGreeting = "Hello, there";
*/

// Using a class as an interface
class Point0 {
    xx: number;
    yy: number;
}

interface Point3d extends Point0 {
    zz: number;
}

let point3d: Point3d = {xx: 1, yy: 2, zz: 3};
