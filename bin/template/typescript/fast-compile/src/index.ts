/* eslint-env node */
/* eslint-disable @typescript-eslint/no-unused-vars, no-console */

//import { B } from "./common"; // for npm run compile until typescript 5 arrives
import { B } from './common.ts' // for npm run fast / compile with typescript@beta == 5

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

// Regex to find Typescript's two ways of declaring
// arrays (not perfect): \bArray<(.+?)>|(\w+|\(.+?\))\[\]
// readonly arrays: \bReadonlyArray<(.+?)>|\breadonly\s+(\w+|\(.+?\))\[\]

// type nothing = undefined | null | false | 0 | 0n | /^\s*$/ | /^\s*0*(.0*)?\s*$/| NaN;
// type empty = undefined | null | false | 0 | 0n | /^\s*$/ | /^\s*0*(.0*)?\s*$/| NaN | [] | {};
type fnAction = () => void
type procedure = () => void

type Named = { name: string }
type Fish = Named & { swim: fnAction }
type Bird = Named & { fly: procedure }
type Pet = Fish | Bird

function isFish(pet: Fish | Bird): pet is Fish {
	return (pet as Fish).swim !== undefined
}

function getSmallPet(): Pet {
	const rand = Math.random()
	const name = rand.toString()
	return (10 * rand) & 1
		? { name: 'fish' + name, swim: () => void 0 }
		: { name: 'bird' + name, fly: () => void 0 }
}

function move(animal: Fish | Bird) {
	if ('swim' in animal) {
		return animal.swim()
	}

	return animal.fly()
}

const zoo: (Fish | Bird)[] = [getSmallPet(), getSmallPet(), getSmallPet()]
console.log(zoo)
const underWater1: Fish[] = zoo.filter(isFish)
// or, equivalently
const underWater2: Fish[] = zoo.filter(isFish) as Fish[]

// The predicate may need repeating for more complex examples
const underWater3: Fish[] = zoo.filter((pet): pet is Fish => {
	if (pet.name === 'sharkey') return false
	return isFish(pet)
})
console.log(underWater3)

interface Circle {
	kind: 'circle'
	radius: number
}

interface Square {
	kind: 'square'
	sideLength: number
}

interface RightTriangle {
	kind: 'rtriangle'
	sideLength: number
	base: number
}

type Shape = Circle | Square | RightTriangle

function getArea(shape: Shape) {
	let area = 0
	switch (shape.kind) {
		case 'circle':
			area = Math.PI * shape.radius ** 2
			break
		case 'square':
			area = shape.sideLength ** 2
			break
		case 'rtriangle':
			area = (shape.sideLength * shape.base) / 2
			break
		default: {
			const _exhaustiveCheck: never = shape
			return _exhaustiveCheck
		}
	}
	return area
}

// A function with a property added to it.
type DescribableFunction = {
	description: string
	(someArg: number): boolean
}
// eslint-disable-next-line @typescript-eslint/ban-types
function doSomething(fn: Function | DescribableFunction) {
	const name =
		((fn as DescribableFunction).description
			? (fn as DescribableFunction).description
			: fn.name) || 'anonymous'
	console.log(name + ' returned ' + fn(6))
}
doSomething((v) => v * v)

interface SomeObject {
	value: string
}

type SomeConstructor = {
	new (s: string): SomeObject
}
function fn(ctor: SomeConstructor) {
	return new ctor('hello')
}

// Like Date() returns string vs new Date() returns a date object
interface CallOrConstruct {
	new (s: string): Date
	(n?: number): number
}

function map<Input, Output>(
	arr: Input[],
	func: (arg: Input) => Output,
): Output[] {
	return arr.map(func)
}

// Parameter 'n' is of type 'string'
// 'parsed' is of type 'number[]'
const parsed = map(['1', '2', '3'], (n) => parseInt(n))

type HasLength = { length: number }

//function longest<Type extends HasLength>(a: Type, b: Type) {
function longest<Type extends { length: number }>(a: Type, b: Type) {
	if (a.length >= b.length) {
		return a
	} else {
		return b
	}
}

// longerArray is of type 'number[]'
const longerArray = longest([1, 2], [1, 2, 3])
// longerString is of type 'alice' | 'bob'
const longerString = longest('alice', 'bob')
// Error! Numbers don't have a 'length' property
//const notOK = longest(10, 100);

// Multiple function signatures
function makeDate(timestamp: number): Date
function makeDate(m: number, d: number, y: number): Date
function makeDate(mOrTimestamp: number, d?: number, y?: number): Date {
	if (d !== undefined && y !== undefined) {
		return new Date(y, mOrTimestamp, d)
	} else {
		return new Date(mOrTimestamp)
	}
}
const d1 = makeDate(12345678)
const d2 = makeDate(5, 5, 5)
//const d3 = makeDate(1, 3);

interface User {
	name: string
	age: number
	admin: boolean
}

interface DB {
	// providing the type info for the 'this' parameter of a function.
	filterUsers(filter: (this: User) => boolean): User[]
}

// tell typescript to assume there is a function already
declare function getDB(): DB
// eslint-disable-next-line no-constant-condition
if (false) {
	const db = getDB()
	const admins = db.filterUsers(function (this: User) {
		return this.admin
	})
	// const admins = db.filterUsers(() => {
	//   return this.admin;
	// });
}

function safeParse(s: string): unknown {
	return JSON.parse(s)
}
const someRandomString = 'asd;lkfjiow4jfo4oje'
// Need to be careful with 'obj'!
// eslint-disable-next-line no-constant-condition
if (false) {
	const obj = safeParse(someRandomString)
}
// function never returns
function fail(msg: string): never {
	throw new Error(msg)
}

type voidFunc = () => void

const vf1: voidFunc = () => {
	return true
}

const vf2: voidFunc = () => true

const vf3: voidFunc = function () {
	return true
}

// BUT literal void functions are not permitted.
function lf2(): void {
	// @ts-expect-error documentation says literal void functions are not permitted
	return true
}

const lf3 = function (): void {
	// @ts-expect-error documentation says literal void functions are not permitted
	return true
}

interface NumberOrStringDictionary {
	[index: string]: number | string
	length: number // ok, length is a number
	name: string // ok, name is a string
}

interface ReadonlyStringArray {
	readonly [index: number]: string
}
declare function getReadOnlyStringArray(): ReadonlyStringArray

// eslint-disable-next-line no-constant-condition
if (false) {
	const myArray: ReadonlyStringArray = getReadOnlyStringArray()
	// myArray[2] = "Mallory"; // cannot change contents
}
// Multiple interface inheritance
interface Colorful {
	color: string
}
interface Circle2 {
	radius: number
}
interface ColorfulCircle extends Colorful, Circle2 {}
type ColorfulCircle2 = Colorful & Circle // intersection type is equivalent to interface extends

const cc: ColorfulCircle = {
	color: 'red',
	radius: 42,
}

// ReadonlyArray is a Typescript built in type
function doStuff(values: ReadonlyArray<string>) {
	// We can read from 'values'...
	const copy = values.slice()
	console.log(`The first value is ${values[0]}`)

	// ...but we can't mutate 'values'.
	// values.push("hello!");
	// Property 'push' does not exist on type 'readonly string[]'.
}

// tuples (limited length arrays or arrays with differnt types in each cell)
// useful for defining common function signatures
type StringNumberBooleans = [string, number, ...boolean[]]
type StringBooleansNumber = [string, ...boolean[], number]
type BooleansStringNumber = [...boolean[], string, number]

function readButtonInput1(...args: [string, number, ...boolean[]]) {
	const [name, version, ...input] = args
	// ...
}
// equivalent...
function readButtonInput2(name: string, version: number, ...input: boolean[]) {
	// ...
}
function readButtonInput3(...args: StringNumberBooleans) {
	// ...
}

// Typing operators indexing, keyof, typeor, ReturnType
type Arrayish = { [n: number]: unknown }
type A = keyof Arrayish // A ~ number
type Mapish = { [k: string]: boolean }
type M = keyof Mapish // M ~ string | number
const s = 'hello'
let n: typeof s // n ~ string
type Predicate = (x: unknown) => boolean
type K = ReturnType<Predicate> // K ~ boolean

type Person = { age: number; name: string; alive: boolean }
type Age = Person['age'] // Age ~ number
type I1 = Person['age' | 'name'] // I1 ~ string | number
type I2 = Person[keyof Person] // I2 ~ string | number | boolean
type AliveOrName = 'alive' | 'name'
type I3 = Person[AliveOrName] // I3 ~ string | boolean

const MyArray = [
	{ name: 'Alice', age: 15 },
	{ name: 'Bob', age: 23 },
	{ name: 'Eve', age: 38 },
]
type Person2 = (typeof MyArray)[number]
type Age2 = (typeof MyArray)[number]['age']
type Age3 = Person['age']

// Conditional typing reduces number of overloads needed
interface IdLabel {
	id: number /* some fields */
}
interface NameLabel {
	name: string /* other fields */
}

function createLabel(id: number): IdLabel
function createLabel(name: string): NameLabel
function createLabel(nameOrId: string | number): IdLabel | NameLabel
function createLabel(nameOrId: string | number): IdLabel | NameLabel {
	throw 'unimplemented'
}
type NameOrId<T extends number | string> = T extends number
	? IdLabel
	: NameLabel
function createLabel2<T extends number | string>(idOrName: T): NameOrId<T> {
	throw 'unimplemented'
}

type MessageOf<T extends { message: unknown }> = T['message']
type MessageOf2<T> = T extends { message: unknown } ? T['message'] : never

interface Email {
	message: string
}
interface Telephone {
	ring(): string
}

type EmailMessageContents = MessageOf<Email> // EmailMessageContents ~ string

type EmailMessageContents2 = MessageOf2<Email> // EmailMessageContents2 ~ string
type PhoneMessageContents = MessageOf2<Telephone> // PhoneMessageContents ~ never

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Flatten<T> = T extends any[] ? T[number] : T
// equivalent to using infer
type Flatten2<Type> = Type extends Array<infer Item> ? Item : Type
// Extracts out the element type.
type Str = Flatten<string[]> // Str ~ string
// Leaves the type alone.
type Num = Flatten<number> // Num ~ number

type GetReturnType<Type> = Type extends (...args: never[]) => infer Return
	? Return
	: never

type Num2 = GetReturnType<() => number> // Num2 ~ number
type Str2 = GetReturnType<(x: string) => string> // Str ~ string
type Bools = GetReturnType<(a: boolean, b: boolean) => boolean[]> // Bools ~ boolean[]
type Nope = GetReturnType<number> // Nope ~ never -- not a function
// type Nope2 = ReturnType<number>; // error

// Distributive application - homogeneity
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type ToArray<Type> = Type extends any ? Type[] : never
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type ToArrayNonDist<Type> = [Type] extends [any] ? Type[] : never

type StrArrOrNumArr = ToArray<string | number> // StrArrOrNumArr ~ string[] | number[]
type StrOrNumArr = ToArrayNonDist<string | number> // StrOrNumArr ~ (string | number)[]

// A quick aside testing order of keys in obj, map, set
const Obj = {}
const M = new Map()
// const W = new WeakMap();
const S = new Set()

function add(k, v) {
	Obj[k] = v
	M.set(k, v)
	S.add(k)
}

add('z', 42)
add('a', 42)
add(0, 42)
add('a', 23)
// import util from 'util'
const log = console.warn // (...args) => { console.warn(args.map((c) => /^(object|function)$/.test(typeof c) ? util.inspect(c) : c).join(" ")) }; // console.warn
log('Obj', Obj)
log('Map', M)
log('Set', S)

// log('Obj', Obj, 'keys:', Object.keys(Obj), 'values:', Object.values(Obj))
// log('Map', M, 'keys:', M.keys(), 'values:', M.values())
// log('Set', S, 'keys:', S.keys(), 'values:', S.values())
// console.warn
// Obj { '0': 42, z: 42, a: 23 } keys: [ '0', 'z', 'a' ] values: [ 42, 42, 23 ]
// Map Map(3) { 'z' => 42, 'a' => 23, 0 => 42 } keys: [Map Iterator] { 'z', 'a', 0 } values: [Map Iterator] { 42, 23, 42 }
// Set Set(3) { 'z', 'a', 0 } keys: [Set Iterator] { 'z', 'a', 0 } values: [Set Iterator] { 'z', 'a', 0 }

// util.inspect
// Obj { '0': 42, z: 42, a: 23 } keys: [ '0', 'z', 'a' ] values: [ 42, 42, 23 ]
// Map Map(3) { 'z' => 42, 'a' => 23, 0 => 42 } keys: [Map Iterator] { 'z', 'a', 0 } values: [Map Iterator] { 42, 23, 42 }
// Set Set(3) { 'z', 'a', 0 } keys: [Set Iterator] { 'z', 'a', 0 } values: [Set Iterator] { 'z', 'a', 0 }

// object with keys in a specific order
interface ordbject {
	keys: Array<string>
	obj: object
}

// Mapped objects
type OptionsFlags<Type> = {
	[Property in keyof Type]: boolean
}
type FeatureFlags = {
	darkMode: () => void
	newUserProfile: () => void
}

type FeatureOptions = OptionsFlags<FeatureFlags>
// type FeatureOptions = {
//     darkMode: boolean;
//     newUserProfile: boolean;
// }

// (- minus) Removes 'readonly' attributes from a type's properties
type CreateMutable<Type> = {
	-readonly [Property in keyof Type]: Type[Property]
}

type LockedAccount = {
	readonly id: string
	readonly name: string
}

type UnlockedAccount = CreateMutable<LockedAccount>
// type UnlockedAccount = {
//     id: string;
//     name: string;
// }

// Removes 'optional' attributes from a type's properties
type Concrete<Type> = {
	[Property in keyof Type]-?: Type[Property]
}
type MaybeUser = {
	id: string
	name?: string
	age?: number
}
type SavedUser = Concrete<MaybeUser>
// type User = {
//     id: string;
//     name: string;
//     age: number;
// }

// Rewriting property names with template literal types
type Getters<Type> = {
	[Property in keyof Type as `get${Capitalize<
		string & Property
	>}`]: () => Type[Property]
}

interface Person3 {
	name: string
	age: number
	location: string
}

type LazyPerson = Getters<Person3>
// type LazyPerson = {
//   getName: () => string;
//   getAge: () => number;
//   getLocation: () => string;
// }

// Remove the 'kind' property
type RemoveKindField<Type> = {
	[Property in keyof Type as Exclude<Property, 'kind'>]: Type[Property]
}

interface Circle {
	kind: 'circle'
	radius: number
}

type KindlessCircle = RemoveKindField<Circle>
// type KindlessCircle = {
//   radius: number;
// }

type EventConfig<Events extends { kind: string }> = {
	[E in Events as E['kind']]: (event: E) => void
}

type SquareEvent = { kind: 'square'; x: number; y: number }
type CircleEvent = { kind: 'circle'; radius: number }

type Config = EventConfig<SquareEvent | CircleEvent>
// type Config = {
//   square: (event: SquareEvent) => void;
//   circle: (event: CircleEvent) => void;
// }

// Flag up fields with Personally Identifieable Information
type ExtractPII<Type> = {
	[Property in keyof Type]: Type[Property] extends { pii: true }
		? true
		: false
}

type DBFields = {
	id: { format: 'incrementing' }
	name: { type: string; pii: true }
}

type ObjectsNeedingGDPRDeletion = ExtractPII<DBFields>

// type ObjectsNeedingGDPRDeletion = {
//     id: false;
//     name: true;
// }

type EmailLocaleIDs = 'welcome_email' | 'email_heading'
type FooterLocaleIDs = 'footer_title' | 'footer_sendoff'

type AllLocaleIDs = `${EmailLocaleIDs | FooterLocaleIDs}_id`
// type AllLocaleIDs = "welcome_email_id" | "email_heading_id" | "footer_title_id" | "footer_sendoff_id"
type Lang = 'en' | 'ja' | 'pt'
type LocaleMessageIDs = `${Lang}_${AllLocaleIDs}`
// type LocaleMessageIDs = "en_welcome_email_id" | "en_email_heading_id" | "en_footer_title_id" | "en_footer_sendoff_id" | "ja_welcome_email_id" | "ja_email_heading_id" | "ja_footer_title_id" | "ja_footer_sendoff_id" | "pt_welcome_email_id" | "pt_email_heading_id" | "pt_footer_title_id" | "pt_footer_sendoff_id"

/*
  Useful types for projects:
  */
type Fproc = () => void
type Fidentity<Type> = (Type) => Type
type Mutable<Type> = {
	-readonly [Property in keyof Type]: Type[Property]
}
// make all properties readonly - use TS builtin utility: Readonly<Type>
type Immutable<Type> = {
	readonly [Property in keyof Type]: Type[Property]
}
type PropCheck<Type> = {
	[Property in keyof Type]: boolean
}
// make all properties required - use TS builtin utility: Required<Type>
type RequireAll<Type> = {
	[Property in keyof Type]-?: Type[Property]
}
// make all properties optional - use TS builtin utility: Partial<Type>
type OptionAll<Type> = {
	[Property in keyof Type]?: Type[Property]
}

interface Rectangle<Type> {
	width: Type
	height: Type
	area: Type
	perimeter: Type
}

class Rect implements Rectangle<bigint> {
	static _id = 0
	// declares properties of each instance
	private _id: number
	private _w = 0n
	private _h = 0n
	private _a = 0n
	private _p = 0n

	constructor(rect: { width: bigint; height: bigint })
	constructor(width?: bigint, height?: bigint)
	constructor(
		widthOrRect?: bigint | { width?: bigint; height?: bigint },
		height = 0n,
	) {
		this._id = Rect._id++
		if (typeof widthOrRect === 'object') {
			this._w = widthOrRect.width || 0n
			this.height = widthOrRect.height || 0n
		} else {
			this._w = widthOrRect || 0n
			this.height = height
		}
	}
	protected _calc(this: Rect) {
		this._a = this._w * this._h
		this._p = 2n * (this._w + this._h)
	}
	get width(): bigint {
		return this._w
	}
	set width(value: bigint | number | string) {
		this._w = BigInt(value)
		this._calc()
	}
	get height(): bigint {
		return this._h
	}
	set height(value: bigint | number | string) {
		this._h = BigInt(value)
		this._calc()
	}
	get area() {
		return this._a
	}
	get perimeter() {
		return this._p
	}
}
Object.getPrototypeOf(Rect).counter = 0

const r = new Rect(2n, 6n)
console.warn('Rect', r, r.area)
r.height = '23'
// r.width = "NaN"
// r.width = NaN
console.warn("Rect'", r, r.area)
console.warn('Rect2', new Rect(r))
console.warn('Rect3', new Rect())
console.warn('Rect::_id', Rect._id)

type ObjectDescriptor<D, M> = {
	data?: D
	methods?: M & ThisType<D & M> // Type of 'this' in methods is D & M
}

function makeObject<D, M>(desc: ObjectDescriptor<D, M>): D & M {
	const data: object = desc.data || {}
	const methods: object = desc.methods || {}
	return { ...data, ...methods } as D & M
}

const obj = makeObject({
	data: { x: 0, y: 0 },
	methods: {
		moveBy(dx: number, dy: number) {
			this.x += dx // Strongly typed this
			this.y += dy // Strongly typed this
		},
	},
})

obj.x = 10
obj.y = 20
console.warn('ThisType D&M Obj', obj)
obj.moveBy(5, 5)
console.warn("ThisType D&M Obj'", obj)

// Prefer modern typescript's as const to using enum's
const enum EDirection {
	Up,
	Down,
	Left,
	Right,
}

const ODirection = {
	Up: 0,
	Down: 1,
	Left: 2,
	Right: 3,
} as const

EDirection.Up // (enum member) EDirection.Up = 0

ODirection.Up // (property) Up: 0

// Using the enum as a parameter
function walk(dir: EDirection) {
	return ODirection.Right - dir
}

// It requires an extra line to pull out the values
type Direction = (typeof ODirection)[keyof typeof ODirection]
function run(dir: Direction) {
	return ODirection.Right - dir
}

walk(EDirection.Left)
run(ODirection.Right)

const pets = new Set(['Cat', 'Dog', 'Hamster'])
pets['species'] = 'mammals'
pets.add('<Mammals')
for (const pet in pets) {
	console.log(`in pets ${pet}: ${pets[pet]}`) // "species"
	console.log(`  pets.has ${pet}:`, pets.has(pet))
}
for (const pet of pets) {
	console.log('of pets', pet) // "Cat", "Dog", "Hamster"
	console.log(`  pets.has ${pet}:`, pets.has(pet))
	console.log(`  in pets ${pet}:`, pet in pets)
}
console.log('keys of pets:', pets.keys())
console.log('Object.keys of pets:', Object.keys(pets))

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
  Objects https://www.typescriptlang.org/docs/handbook/2/objects.html
    - Annotating types as readonly tuples when possible is a good default.
  Classes https://www.typescriptlang.org/docs/handbook/2/classes.html
    - Note that a field-backed get/set pair with no extra logic is very rarely useful in JavaScript. It’s fine to expose public fields if you don’t need to add additional logic during the get/set operations.
  Utility Types https://www.typescriptlang.org/docs/handbook/utility-types.html
    - utilities for async/Promise: Await<Type>
    - utilities for properties of types: Partial<Type>, Required<Type>, Readonly<Type>, Record<Keys, Type>, Pick<Type, Keys>, Omit<Type, Keys>
    - utilities for type unions: Exclude<Un1, Un2>, Extract<Un1, Un2>, NonNullable<Un>
    - utilities for functions: Parameters<Fn>, ConstructorParameters<CFn>, ReturnType<Fn>, InstanceType<CFn>, ThisParameterType<Fn>, OmitThisParameterType<Fn>, ThisType<Type>
    - utilities for strings: Uppercase<Str>, Lowercase<Str>, Capitalize<Str>, Uncapitalize<Str>
  - like Awaited, Promise, Capitalize, etc
  Enums https://www.typescriptlang.org/docs/handbook/enums.html
    - prefer modern typescript's object as const to enums

HEREIAM
https://www.typescriptlang.org/docs/handbook/module-resolution.html
*/

/*
ChatGPT has nothing so eloquent as Rand, that's for sure.

chatgpt, What are values?

A: Values are principles or standards that an individual, group, or society considers important or desirable. They serve as a guide for behavior and decision making, and often reflect one's beliefs and priorities. Examples of values include honesty, compassion, fairness, equality, responsibility, and respect.

Q: Why does man need values?

A: Man needs values for several reasons:

Direction and purpose: Values provide direction and purpose in life, helping individuals make decisions and set goals that align with their beliefs and priorities.
Personal and social identity: Values help shape an individual's personal identity and social identity, as they reflect what a person believes in and stand for.
Guiding behavior: Values serve as a moral compass, helping individuals act in accordance with what they believe to be right and wrong.
Building relationships: Values help build and maintain relationships, as individuals who share similar values tend to have a stronger connection.
Promoting stability and order: Values help promote stability and order in society by providing a shared sense of what is important and acceptable.
Overall, values play a crucial role in shaping an individual's worldview and guiding their behavior, both personally and socially.


Q: Is there an objective moral code?

A: The question of whether there is an objective moral code is a philosophical and religious debate that has been ongoing for centuries.
Some people believe in an objective moral code that exists independently of human opinion, often rooted in religious or spiritual beliefs. According to this view, there are certain universal moral principles that apply to all people and situations, regardless of cultural or individual differences.
Others argue that morality is subjective and culturally relative, with values and norms that vary from one society to another. These individuals believe that moral principles are created and maintained by human societies, and are not based on any objective, universal standard.
The debate over the existence of an objective moral code is complex and cannot be definitively resolved, as it is ultimately a matter of personal belief. However, both perspectives continue to influence ethical and moral reasoning and inform personal and societal decision-making.
*/
