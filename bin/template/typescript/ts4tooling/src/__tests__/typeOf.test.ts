import { describe, expect, test } from '@jest/globals'
import typeOf from '../typeOf'

describe('typeOf() module tests', function descTypeOfSuite() {
	/* eslint-disable @typescript-eslint/no-unsafe-return */
	const fnThisIdentity = (x) => x
	const fnIdentity = function (x) {
		return x
	}
	/* eslint-enable @typescript-eslint/no-unsafe-return */

	test('primitive types', function testTypeOfPrimitive() {
		expect(typeOf(void 0)).toBe('undefined')

		expect(typeOf(false)).toBe('boolean')
		expect(typeOf(true)).toBe('boolean')

		expect(typeOf(0)).toBe('number')
		expect(typeOf(0.5)).toBe('number')
		expect(typeOf(-1)).toBe('number')
		expect(typeOf(1)).toBe('number')
		expect(typeOf(NaN)).toBe('number')
		expect(typeOf(Infinity)).toBe('number')

		// expect(typeOf(0n)).toBe('number')

		expect(typeOf('')).toBe('string')
		expect(typeOf('whatever')).toBe('string')
	}) // primitive types

	test('abnormal primitive types', function testTypeOfAbnormalPrimitive() {
		expect(typeOf(null)).toBe('null')
	}) // abnormal primitive types

	test('object-like types', function testTypeOfPrimitive() {
		expect(typeOf(/matchThis/)).toBe('object:RegExp')
		expect(typeOf([])).toBe('object:Array')
		expect(typeOf({})).toBe('object')
		expect(typeOf(fnThisIdentity)).toBe('function')
		expect(typeOf(fnIdentity)).toBe('function')
		expect(typeOf(new Date())).toBe('object:Date')
		expect(typeOf(new Set())).toBe('object:Set')
		expect(typeOf(new Map())).toBe('object:Map')

		interface TwoD {
			x: number
			y: number
		}
		interface ThreeD {
			x: number
			y: number
			z: number
		}

		const anon: TwoD = new (function (this: TwoD, x: number, y: number) {
			this.x = x
			this.y = y
		})(1, -1) as TwoD

		const anon2: ThreeD = new (function (
			this: ThreeD,
			x: number,
			y: number,
			z: number,
		) {
			this.x = x
			this.y = y
			this.z = z
		})(1, -1, 0) as ThreeD
		expect(typeOf(anon)).toBe('object:Anon') // Anon0
		expect(typeOf(anon2)).toBe('object:Anon') // Anon1
		expect(typeOf(anon2)).toBe(typeOf(anon)) // MUSTDO(BSAC) should be .not.
	}) // object-like types
})
