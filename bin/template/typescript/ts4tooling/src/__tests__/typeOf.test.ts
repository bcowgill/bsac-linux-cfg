import { describe, expect, test } from '@jest/globals'
import typeOf from '../typeOf'

describe('typeOf() module tests', function descTypeOfSuite() {
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
		expect(typeOf(function () {})).toBe('function')
		expect(typeOf(() => {})).toBe('function')
		expect(typeOf(new Date())).toBe('object:Date')
		expect(typeOf(new Set())).toBe('object:Set')
		expect(typeOf(new Map())).toBe('object:Map')

		const anon = new (function (x, y) {
			this.x = x
			this.y = y
		})(1, -1)
		const anon2 = new (function (x, y, z) {
			this.x = x
			;(this.y = y), (this.z = z)
		})(1, -1, 0)
		expect(typeOf(anon)).toBe('object:Anon') // Anon0
		expect(typeOf(anon2)).toBe('object:Anon') // Anon1
		expect(typeOf(anon2)).not.toBe(typeOf(anon))
	}) // object-like types
})
