import { describe, expect, test } from '@jest/globals'
import * as testMe from '../JSONSet'

const displayName = 'JSONSet'

describe(`${displayName} module tests`, function descJSONSetModuleSuite() {
	type stuff = string | number | boolean
	const items: stuff[] = ['hello', 42, false, 'world']
	const set = new Set(items)

	describe(`${displayName}()`, function descJSONSetSuite() {
		test('JSON.stringify does not handle Set objects', function testJSONStringifySet() {
			const got = JSON.stringify(set)
			expect(got).toBe('{}') // Not very useful
		})

		test('should supply default parameters', function testJSONSetDefault() {
			expect(testMe.JSONSet(set)).toEqual(['object:JSONSet', ...items])
		})

		test('should limit the number of items shown', function testJSONSetLimit() {
			expect(testMe.JSONSet(set, 1)).toEqual([
				'object:JSONSet',
				'hello',
				'…',
			])
			expect(testMe.JSONSet(set, 2)).toEqual([
				'object:JSONSet',
				'hello',
				42,
				'…',
			])
			expect(testMe.JSONSet(set, 3)).toEqual([
				'object:JSONSet',
				'hello',
				42,
				false,
				'…',
			])
			expect(testMe.JSONSet(set, 4)).toEqual(['object:JSONSet', ...items])
			expect(testMe.JSONSet(set, 5)).toEqual(['object:JSONSet', ...items])
		})
	}) // JSONSet()
	describe(`SetFromJSON()`, function descSetFromJSONSuite() {
		test('should convert array to a Set', function testSetFromJSONOk() {
			const newSet = testMe.SetFromJSON(['object:JSONSet', ...items])

			expect(newSet.size).toEqual(4)
			expect(newSet.has('object:JSONSet')).toBeFalsy()
			expect(newSet.has(items[0])).toBeTruthy()
			const values: stuff[] = []
			newSet.forEach((item) => values.push(item))
			expect(values.sort()).toEqual(items.sort())
		})

		test('should convert array to an empty Set', function testSetFromJSONEmpty() {
			const newSet = testMe.SetFromJSON(['object:JSONSet'])

			expect(newSet.size).toEqual(0)
		})

		test('should throw when array is not an object:JSONSet', function testSetFromJSONError() {
			expect(() => testMe.SetFromJSON(['wrong'])).toThrowError(
				new TypeError(
					"Cannot construct a Set from non-JSONArrayish, first element of array must be 'object:JSONSet'. (Found 'wrong')",
				),
			)
		})
	}) // SetFromJSON
})
