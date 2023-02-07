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