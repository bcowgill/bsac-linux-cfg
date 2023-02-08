//import { B } from "./common"; // for npm run compile until typescript 5 arrives
import { B } from "./common.ts"; // for npm run fast / compile with typescript@beta == 5

console.log(B)

/* sample TS type error
const user = {
  firstName: "Angela",
  lastName: "Davis",
  role: "Professor",
}

console.log(user.name)
*/

// Typescript samples from the Handbook
// https://www.typescriptlang.org/docs/handbook/2/narrowing.html

// Regex to find Typescripts two ways of declaring arrays (not perfect): \bArray<(.+?)>|(\w+|\(.+?\))\[\]


// type nothing = undefined | null | false | 0 | 0n | /^\s*$/ | /^\s*0*(.0*)?\s*$/| NaN;
// type empty = undefined | null | false | 0 | 0n | /^\s*$/ | /^\s*0*(.0*)?\s*$/| NaN | [] | {};
type fnAction = () => void;
type procedure = () => void;

type Named = { name: string };
type Fish = Named & { swim: fnAction };
type Bird = Named & { fly: procedure };
type Pet = Fish | Bird;

function isFish(pet: Fish | Bird): pet is Fish {
  return (pet as Fish).swim !== undefined;
}

function getSmallPet(): Pet {
  const rand = Math.random()
  const name = rand.toString()
  return ((10 * rand) & 1) ? { name: 'fish' + name, swim: () => void 0 } : { name: 'bird' + name, fly: () => void 0 };
}

function move(animal: Fish | Bird) {
  if ("swim" in animal) {
    return animal.swim();
  }

  return animal.fly();
}

const zoo: (Fish | Bird)[] = [getSmallPet(), getSmallPet(), getSmallPet()];
console.log(zoo)
const underWater1: Fish[] = zoo.filter(isFish);
// or, equivalently
const underWater2: Fish[] = zoo.filter(isFish) as Fish[];

// The predicate may need repeating for more complex examples
const underWater3: Fish[] = zoo.filter((pet): pet is Fish => {
  if (pet.name === "sharkey") return false;
  return isFish(pet);
});
console.log(underWater3)

interface Circle {
  kind: "circle";
  radius: number;
}

interface Square {
  kind: "square";
  sideLength: number;
}

interface RightTriangle {
  kind: "rtriangle";
  sideLength: number;
  base: number;
}

type Shape = Circle | Square | RightTriangle;

function getArea(shape: Shape) {
  let area = 0
  switch (shape.kind)  {
    case "circle":
      area = Math.PI * shape.radius ** 2;
      break;
    case "square":
      area = shape.sideLength ** 2;
      break;
    case "rtriangle":
      area = shape.sideLength * shape.base / 2;
      break;
    default:
      const _exhaustiveCheck: never = shape;
      return _exhaustiveCheck;
  }
  return area
}

// A function with a property added to it.
type DescribableFunction = {
  description: string;
  (someArg: number): boolean;
};
function doSomething(fn: Function | DescribableFunction) {
  const name = ((fn as DescribableFunction).description? (fn as DescribableFunction).description : fn.name) || 'anonymous'
  console.log(name + " returned " + fn(6));
}
doSomething((v) => v * v)

interface SomeObject {
  value: string
}

type SomeConstructor = {
  new (s: string): SomeObject;
};
function fn(ctor: SomeConstructor) {
  return new ctor("hello");
}

// Like Date() returns string vs new Date() returns a date object
interface CallOrConstruct {
  new (s: string): Date;
  (n?: number): number;
}

function map<Input, Output>(arr: Input[], func: (arg: Input) => Output): Output[] {
  return arr.map(func);
}

// Parameter 'n' is of type 'string'
// 'parsed' is of type 'number[]'
const parsed = map(["1", "2", "3"], (n) => parseInt(n));

type HasLength = { length: number }

//function longest<Type extends HasLength>(a: Type, b: Type) {
function longest<Type extends { length: number }>(a: Type, b: Type) {
  if (a.length >= b.length) {
    return a;
  } else {
    return b;
  }
}

// longerArray is of type 'number[]'
const longerArray = longest([1, 2], [1, 2, 3]);
// longerString is of type 'alice' | 'bob'
const longerString = longest("alice", "bob");
// Error! Numbers don't have a 'length' property
//const notOK = longest(10, 100);

// Multiple function signatures
function makeDate(timestamp: number): Date;
function makeDate(m: number, d: number, y: number): Date;
function makeDate(mOrTimestamp: number, d?: number, y?: number): Date {
  if (d !== undefined && y !== undefined) {
    return new Date(y, mOrTimestamp, d);
  } else {
    return new Date(mOrTimestamp);
  }
}
const d1 = makeDate(12345678);
const d2 = makeDate(5, 5, 5);
//const d3 = makeDate(1, 3);

interface User {
  name: string,
  age: number,
  admin: boolean,
}

interface DB {
  // providing the type info for the 'this' parameter of a function.
  filterUsers(filter: (this: User) => boolean): User[];
}

// tell typescript to assume there is a function already
declare function getDB(): DB
if (false) {
  const db = getDB();
  const admins = db.filterUsers(function (this: User) {
    return this.admin;
  });
  // const admins = db.filterUsers(() => {
    //   return this.admin;
    // });
}

function safeParse(s: string): unknown {
  return JSON.parse(s);
}
const someRandomString = "asd;lkfjiow4jfo4oje"
// Need to be careful with 'obj'!
if (false) {
  const obj = safeParse(someRandomString);
}
// function never returns
function fail(msg: string): never {
  throw new Error(msg);
}

type voidFunc = () => void;

const vf1: voidFunc = () => {
  return true;
};

const vf2: voidFunc = () => true;

const vf3: voidFunc = function () {
  return true;
};

// BUT literal void functions are not permitted.
function lf2(): void {
  // @ts-expect-error
  return true;
}

const lf3 = function (): void {
  // @ts-expect-error
  return true;
};

interface NumberOrStringDictionary {
  [index: string]: number | string;
  length: number; // ok, length is a number
  name: string; // ok, name is a string
}

interface ReadonlyStringArray {
  readonly [index: number]: string;
}
declare function getReadOnlyStringArray() : ReadonlyStringArray

if (false) {
  let myArray: ReadonlyStringArray = getReadOnlyStringArray();
  // myArray[2] = "Mallory"; // cannot change contents
}
// Multiple interface inheritance
interface Colorful { color: string; }
interface Circle2 { radius: number; }
interface ColorfulCircle extends Colorful, Circle2 {}
type ColorfulCircle2 = Colorful & Circle; // intersection type is equivalent to interface extends

const cc: ColorfulCircle = {
  color: "red",
  radius: 42,
};

// ReadonlyArray is a Typescript built in type
function doStuff(values: ReadonlyArray<string>) {
  // We can read from 'values'...
  const copy = values.slice();
  console.log(`The first value is ${values[0]}`);

  // ...but we can't mutate 'values'.
  // values.push("hello!");
  // Property 'push' does not exist on type 'readonly string[]'.
}

/*
  Typescript Handbook Rules of Thumb for adding type information:
    - Prefer to use interface to type until you need to use type specific features.

  Everyday Types https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
    - The type names String, Number, and Boolean (starting with capital letters) are legal, but refer to some special built-in types that will very rarely appear in your code. Always use string, number, or boolean for types.
    - TypeScript doesn’t use “types on the left”-style declarations like int x = 0; Type annotations will always go after the thing being typed.
    - Even if you don’t have type annotations on your parameters, TypeScript will still check that you passed the right number of arguments.
    - Reminder: Because type assertions are removed at compile-time, there is no runtime checking associated with a type assertion. There won’t be an exception or null generated if the type assertion is wrong.

  Functions https://www.typescriptlang.org/docs/handbook/2/functions.html
    - Rule: When possible, use the <Type> parameter itself rather than constraining it.
    - Rule: Always use as few <Type> parameters as possible.
    - Rule: If a <Type> parameter only appears in one location, strongly reconsider if you actually need it.
    - When writing a function type for a callback, never write an optional parameter unless you intend to call the function without passing that argument.
    - Always have two or more signatures above the implementation of the function when writing an overloaded function.  The signature of the implementation is not visible from the outside.
    - Always prefer parameters with union types instead of overloads when possible.
    - void is not the same as undefined.
    - object is not Object. Always use object! (functions are objects, so is array.)
    - unknown is similar to the any type, but is safer because it’s not legal to do anything with an unknown value.
    - never type represents values which are never observed.
    - Function is an untyped function call and is generally best avoided because of the unsafe any return type. Prefer () => void.
   HEREIAM Objects https://www.typescriptlang.org/docs/handbook/2/objects.html

*/

