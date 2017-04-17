//===============================================================
// generic functions

// The <T> after the function name symbolizes that it's a generic function.
// When we call the function, every instance of T will be replaced with the actual provided type.

// Receives one argument of type T,
// Returns an array of type T.

function genericFunc<T>(argument: T): T[] {
  var arrayOfT: T[] = [];    // Create empty array of type T.
  arrayOfT.push(argument);   // Push, now arrayOfT = [argument].
  return arrayOfT;
}

var arrayFromString = genericFunc<string>("beep");
console.log(arrayFromString[0]);         // "beep"
console.log(typeof arrayFromString[0])   // String

var arrayFromNumber = genericFunc(42);
console.log(arrayFromNumber[0]);         // 42
console.log(typeof arrayFromNumber[0])   // number

// the identity function for a number
function identityN(arg: number): number {
    return arg;
}

// or using any but lose info about types
function identityA(arg: any): any {
    return arg;
}

// using generice to preserve type info
function identity<T>(arg: T): T {
    return arg;
}

// calling generics specifically or implicitly
let output = identity<string>("myString");  // type of output will be 'string'

output = identity("myString");  // type of output will be 'string'

// generic type parameters can be anything and this is enforced
function loggingIdentity<T>(arg: T): T {
    //ERR console.log(arg.length);  // Error: T doesn't have .length
    return arg;
}

// specify an array of the parameter type to use .length
function loggingIdentity2<T>(arg: T[]): T[] {
    console.log(arg.length);  // Array has a .length, so no more error
    return arg;
}

// equivalent way to specify an array of the parameter type
function loggingIdentity3<T>(arg: Array<T>): Array<T> {
    console.log(arg.length);  // Array has a .length, so no more error
    return arg;
}

// generic function types assigned to variables
let myIdentity: <U>(arg: U) => U = identity;
let myIdentity2: {<T>(arg: T): T} = identity;

// Generic interfaces using type parameters
interface GenericIdentityFn {
    <T>(arg: T): T;
}

function identityI<T>(arg: T): T {
    return arg;
}

let myIdentityI: GenericIdentityFn = identity;

// Generic interface where type parameter is part of the whole interface
interface GenericIdentityFnI<T> {
    (arg: T): T;
}

function identityII<T>(arg: T): T {
    return arg;
}

let myIdentityII: GenericIdentityFnI<number> = identity;

// generic class interfaces
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}

let myGenericNumber = new GenericNumber<number>();
myGenericNumber.zeroValue = 0;
myGenericNumber.add = function(x, y) { return x + y; };

let stringNumeric = new GenericNumber<string>();
stringNumeric.zeroValue = "";
stringNumeric.add = function(x, y) { return x + y; };

alert(stringNumeric.add(stringNumeric.zeroValue, "test"));

// Generic contstraints
interface Lengthwise {
    length: number;
}

function loggingIdentityLW<T extends Lengthwise>(arg: T): T {
    console.log(arg.length);  // Now we know it has a .length property, so no more error
    return arg;
}

// won't work with just any type only those with a length property
//ERR loggingIdentityLW(3);  // Error, number doesn't have a .length property
loggingIdentityLW({ length: 10, value: 3 });
loggingIdentityLW([])

// Constraining parameter types by keys of other types
function getProperty<T, K extends keyof T>(obj: T, key: K) {
    return obj[key];
}

let xx = { a: 1, b: 2, c: 3, d: 4 };

getProperty(xx, "a"); // okay, a is a key of xx
//ERR getProperty(xx, "m"); // error: Argument of type 'm' isn't assignable to 'a' | 'b' | 'c' | 'd'.

// generic class factories specify a class constructor function and the class prototype
function create<T>(c: {new(): T; }): T {
    return new c();
}

class BeeKeeper {
    hasMask: boolean;
}

class ZooKeeper {
    nametag: string;
}

class AnimalT {
    numLegs: number;
}

class Bee extends AnimalT {
    keeper: BeeKeeper;
}

class Lion extends AnimalT {
    keeper: ZooKeeper;
}

function findKeeper<A extends AnimalT, K> (a: {new(): A;
    prototype: {keeper: K}}): K {

    return a.prototype.keeper;
}

findKeeper(Lion).nametag;  // typechecks!
