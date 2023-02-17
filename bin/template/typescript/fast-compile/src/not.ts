/* eslint-env node */
/* eslint-disable @typescript-eslint/no-unused-vars, no-console */

//import { B } from "./common"; // for npm run compile until typescript 5 arrives
import { B } from './common.ts' // for npm run fast / compile with typescript@beta == 5

console.log(B)

// Very strange, if these examples area added to index.ts they generate weird
// errors with the rust compiler (npm run build)
// but they all work just fine here by themselves. so may be a limit on file size
// or there was some other conflict between symbols

//----------

interface Rectangle<Type> {
	width: Type
	height: Type
	area: Type
	perimeter: Type
}

class Rect implements Rectangle<bigint> {
	static __id = 0
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
		this._id = Rect.__id++
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

	log(what: string, ...more) {
		console.warn(`Rect.__id=${Rect.__id} ${what}`, this, ...more)
	}
}
// Object.getPrototypeOf(Rect).counter = 0

const r = new Rect(2n, 6n)
r.log('Rect', r.area)
r.height = '23'
// r.width = "NaN"
// r.width = NaN
r.log("Rect'", r.area)
const r2 = new Rect(r)
r2.log('Rect2')
const r3 = new Rect()
r3.log('Rect3') // If enabled rust compiler blows up with strange message!!

//----------

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

//----------

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
