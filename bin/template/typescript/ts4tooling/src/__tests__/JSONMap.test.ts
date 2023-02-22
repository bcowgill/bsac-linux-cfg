import { describe, expect, test } from '@jest/globals'
import * as testMe from '../JSONMap'

const displayName = 'JSONMap'

describe(`${displayName} module tests`, function descJSONMapModuleSuite() {
	type stuff = string | number | boolean
	type kvPair = [stuff, stuff]
	type kvPairs = kvPair[]

	const TYPE = testMe.displayName
	const ELLIPSIS: kvPair = testMe.ELLIPSIS
	const ELLIPSIS2: kvPair = ['...', '...']
	const items: kvPairs = [
		['hello', 42],
		[false, 'world'],
		[45, 'sided'],
		['thicken', true],
	]
	const map = new Map(items)

	describe(`${displayName}()`, function descJSONMapSuite() {
		test('JSON.stringify does not handle Map objects', function testJSONStringifyMap() {
			const got = JSON.stringify(map)
			expect(got).toBe('{}') // Not very useful
		})

		test('JSON.stringify does not handle Function objects', function testJSONStringifyFunction() {
			const got = JSON.stringify({
				split: function SplitMe(str: string, ch: string | RegExp) {
					return str.split(ch)
				},
			})
			expect(got).toBe('{}') // Not very useful would at least be nice to know there was a function there
			// ['object:Function', fn.name, fn.length] -- gives name and # of parameters in function
		})

		test('JSON.stringify does handle Date objects as string value', function testJSONStringifyDate() {
			const got = JSON.stringify(new Date())
			expect(got).toMatch(/^"[-0-9]+T[.:0-9]+Z"$/) // somewhat useful but not as reversable
		})

		test('JSON.stringify does not handle WeakMap objects', function testJSONStringifyWeakMap() {
			type kvPairWM = [object, string]
			type kvPairsWM = kvPairWM[]

			const weakMap = new WeakMap([
				[map, 'MAP'],
				[global, 'GLOBAL'],
			] as kvPairsWM)
			const got = JSON.stringify(weakMap)
			expect(got).toBe('{}') // Not very useful, BUT weak map cannot iterate its keys so it's all that is possible
		})

		test('should supply default parameters', function testJSONMapDefault() {
			expect(testMe.JSONMap(map)).toEqual([TYPE, ...items])
		})

		test('should limit the number of items shown', function testJSONMapLimit() {
			expect(testMe.JSONMap(map, 1)).toEqual([
				TYPE,
				['hello', 42],
				ELLIPSIS,
			])
			expect(testMe.JSONMap(map, 2)).toEqual([
				TYPE,
				['hello', 42],
				[false, 'world'],
				ELLIPSIS,
			])
			expect(testMe.JSONMap(map, 3)).toEqual([
				TYPE,
				['hello', 42],
				[false, 'world'],
				[45, 'sided'],
				ELLIPSIS,
			])
			expect(testMe.JSONMap(map, 4)).toEqual([TYPE, ...items])
			expect(testMe.JSONMap(map, 5)).toEqual([TYPE, ...items])
		})

		test('should limit the number of items shown using a custom ellipsis object', function testJSONMapEllipsis() {
			expect(testMe.JSONMap(map, 1, ELLIPSIS2)).toEqual([
				TYPE,
				['hello', 42],
				ELLIPSIS2,
			])
		})
	}) // JSONMap()

	describe(`MapFromJSON()`, function descMapFromJSONSuite() {
		test('should convert array to a Map', function testMapFromJSONOk() {
			const newMap = testMe.MapFromJSON([TYPE, ...items])

			expect(newMap.size).toEqual(4)
			expect(newMap.has(TYPE)).toBeFalsy()
			expect(newMap.has(items[0][0])).toBeTruthy()
			const values: kvPairs = []
			newMap.forEach((value, key) => values.push([key, value]))
			expect(values).toEqual(items)
		})

		test('should convert array to a Map with custom ellipsis', function testMapFromJSONEllipsis() {
			const newMap = testMe.MapFromJSON(
				[TYPE, ...items, ELLIPSIS2],
				ELLIPSIS2,
			)

			expect(newMap.size).toEqual(4)
			expect(newMap.has(TYPE)).toBeFalsy()
			expect(newMap.has(items[0][0])).toBeTruthy()
			const values: kvPairs = []
			newMap.forEach((value, key) => values.push([key, value]))
			expect(values).toEqual(items)
		})

		test('should convert array to an empty Map', function testMapFromJSONEmpty() {
			const newMap = testMe.MapFromJSON([TYPE])

			expect(newMap.size).toEqual(0)
		})

		test('should throw when array is not an object:JSONMap', function testMapFromJSONError() {
			expect(() => testMe.MapFromJSON(['wrong'])).toThrowError(
				new TypeError(
					`Cannot construct a Map from non-JSONMapish, first element of array must be '${TYPE}'. (Found 'wrong')`,
				),
			)
		})
	}) // MapFromJSON
})
