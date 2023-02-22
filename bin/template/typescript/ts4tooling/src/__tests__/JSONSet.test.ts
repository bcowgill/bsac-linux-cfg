import { describe, expect, test } from '@jest/globals'
import * as testMe from '../JSONSet'

const displayName = 'JSONSet'

describe(`${displayName} module tests`, function descJSONSetModuleSuite() {
	type stuff = string | number | boolean
	const TYPE = testMe.displayName
	const ELLIPSIS = testMe.ELLIPSIS
	const ELLIPSIS2 = '...'
	const items: stuff[] = ['hello', 42, false, 'world']
	const set = new Set(items)

	describe(`${displayName}()`, function descJSONSetSuite() {
		test('JSON.stringify does not handle Set objects', function testJSONStringifySet() {
			const got = JSON.stringify(set)
			expect(got).toBe('{}') // Not very useful
		})

		test('should supply default parameters', function testJSONSetDefault() {
			expect(testMe.JSONSet(set)).toEqual([TYPE, ...items])
		})

		test('should limit the number of items shown', function testJSONSetLimit() {
			expect(testMe.JSONSet(set, 1)).toEqual([TYPE, 'hello', ELLIPSIS])
			expect(testMe.JSONSet(set, 2)).toEqual([
				TYPE,
				'hello',
				42,
				ELLIPSIS,
			])
			expect(testMe.JSONSet(set, 3)).toEqual([
				TYPE,
				'hello',
				42,
				false,
				ELLIPSIS,
			])
			expect(testMe.JSONSet(set, 4)).toEqual([TYPE, ...items])
			expect(testMe.JSONSet(set, 5)).toEqual([TYPE, ...items])
		})

		test('should limit the number of items shown with custom ellipsis', function testJSONSetEllipsis() {
			expect(testMe.JSONSet(set, 1, ELLIPSIS2)).toEqual([
				TYPE,
				'hello',
				ELLIPSIS2,
			])
		})
	}) // JSONSet()

	describe(`SetFromJSON()`, function descSetFromJSONSuite() {
		test('should convert array to a Set', function testSetFromJSONOk() {
			const newSet = testMe.SetFromJSON([TYPE, ...items])

			expect(newSet.size).toEqual(4)
			expect(newSet.has(TYPE)).toBeFalsy()
			expect(newSet.has(items[0])).toBeTruthy()
			const values: stuff[] = []
			newSet.forEach((item) => values.push(item))
			expect(values).toEqual(items) // preserves insertion order
		})

		test('should convert array to a Set with custom ellipsis', function testSetFromJSONEllipsis() {
			const newSet = testMe.SetFromJSON(
				[TYPE, ...items, ELLIPSIS2],
				ELLIPSIS2,
			)

			expect(newSet.size).toEqual(4)
			expect(newSet.has(TYPE)).toBeFalsy()
			expect(newSet.has(items[0])).toBeTruthy()
			const values: stuff[] = []
			newSet.forEach((item) => values.push(item))
			expect(values).toEqual(items) // preserves insertion order
		})

		test('should convert array to an empty Set', function testSetFromJSONEmpty() {
			const newSet = testMe.SetFromJSON([TYPE])

			expect(newSet.size).toEqual(0)
		})

		test('should throw when array is not an object:JSONSet', function testSetFromJSONError() {
			expect(() => testMe.SetFromJSON(['wrong'])).toThrowError(
				new TypeError(
					`Cannot construct a Set from non-JSONArrayish, first element of array must be '${TYPE}'. (Found 'wrong')`,
				),
			)
		})
	}) // SetFromJSON
})
