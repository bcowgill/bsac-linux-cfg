import { describe, expect, test } from '@jest/globals'
import { JSONDateish, rePrefixedDate } from '../JSONDate'
import { JSONDebugLimits } from '../JSONDebug'
import * as testMe from '../JSONDebug'

const displayName = 'JSONDebug'

describe(`${displayName} module tests`, function descJSONDebugModuleSuite() {
	type stuff = string | number | boolean
	type kvPair = [stuff, stuff]
	type kvPairs = kvPair[]

	const setItems: stuff[] = ['hello', 42, false, 'world']

	const mapItems: kvPairs = [
		['hello', 42],
		[false, 'world'],
		[45, 'sided'],
		['thicken', true],
	]

	function fnFunc(x: number, y: number, z = 0) {
		return (x + y) * z
	}

	const date = new Date()
	const reDate = /^"?[-0-9]+T[.:0-9]+Z"?$/
	const regex = /^this is the source$/gimuy
	const set = new Set(setItems)
	const map = new Map(mapItems)

	const Big = {
		fat: 'man',
		little: true,
		boy: 554,
		peep: void 0,
		show: null,
		date,
		set,
		map,
		fnFunc,
		reDate,
		list: [1, 2, 3, 4, 5, 6],
	}

	const limits: JSONDebugLimits = {
		withFunctions: false,
		items: 1,
		arrayLimit: 3,
		setLimit: 2,
		mapLimit: 1,
		ellipsis: '...',
		mapEllipsis: ['...', '...'],
	}

	describe('replacerDebug()', function descJSONDebugReplacerDebugSuite() {
		test('should handle a Function with replacerDebug', function testJSONDebugReplacerDebugFunction() {
			const json = JSON.stringify(fnFunc, testMe.replacerDebug)
			expect(json).toBe('["object:JSONFunction","fnFunc",2]')
		})

		test('JSON.stringify does not handle Set objects', function testJSONStringifySet() {
			const got = JSON.stringify(set)
			expect(got).toBe('{}') // Not very useful
		})

		test('JSON.stringify does not handle RegExp objects', function testJSONStringifyRegExp() {
			const got = JSON.stringify(regex)
			expect(got).toBe('{}') // Not very useful
		})

		test('should handle a RegExp with replacerDebug', function testJSONDebugReplacerDebugRegExp() {
			const json = JSON.stringify(regex, testMe.replacerDebug)
			expect(JSON.parse(json)).toEqual([
				'object:JSONRegExp',
				'^this is the source$',
				'gimuy',
			])
		})

		test('JSON.stringify does handle Date objects as string value but could be better', function testJSONStringifyDate() {
			const got = JSON.stringify(new Date())
			expect(got).toMatch(reDate) // somewhat useful but not as reversable or useful for debugging logs
		})

		test('should handle a Date with replacerDebug', function testJSONDebugReplacerDebugDate() {
			const json = JSON.stringify(new Date(), testMe.replacerDebug)
			const date = JSON.parse(json) as JSONDateish
			expect(date.length).toBe(3)
			expect(date[0]).toBe('object:JSONDate')
			expect(date[1]).toMatch(rePrefixedDate)
			expect(Object.keys(date[2] ?? {})).toEqual([
				'utc',
				'epoch',
				'timeFormatted',
				'localeFormatted',
				'locale',
				'calendar',
				'numberingSystem',
				'timeZone',
				'year',
				'month',
				'day',
			])
		})

		test('JSON.stringify does not handle Function objects', function testJSONStringifyFunction() {
			const got = JSON.stringify({
				split: function SplitMe(str: string, ch: string | RegExp) {
					return str.split(ch)
				},
			})
			expect(got).toBe('{}') // Not very useful would at least be nice to know there was a function there
		})

		test('should handle a Set with replacerDebug', function testJSONDebugReplacerDebugSet() {
			const json = JSON.stringify(set, testMe.replacerDebug)
			expect(JSON.parse(json)).toEqual(['object:JSONSet', ...setItems])
		})

		test('JSON.stringify does not handle Map objects', function testJSONStringifyMap() {
			const got = JSON.stringify(map)
			expect(got).toBe('{}') // Not very useful
		})

		test('should handle a Map with replacerDebug', function testJSONDebugReplacerDebugMap() {
			const json = JSON.stringify(map, testMe.replacerDebug)
			expect(JSON.parse(json)).toEqual(['object:JSONMap', ...mapItems])
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

		test.skip('should limit number of items output with options', function testJSONDebugReplacerDebugLimits() {
			const json = JSON.stringify(Big, testMe.replacerDebug)
			expect(JSON.parse(json)).toEqual({})
		})

		/*
		test('should limit the number of items shown', function testJSONDebugLimit() {
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
			expect(testMe.JSONMap(map, 4)).toEqual([TYPE, ...mapItems])
			expect(testMe.JSONMap(map, 5)).toEqual([TYPE, ...mapItems])
		})

		test('should limit the number of mapItems shown using a custom ellipsis object', function testJSONMapEllipsis() {
			expect(testMe.JSONMap(map, 1, ELLIPSIS2)).toEqual([
				TYPE,
				['hello', 42],
				ELLIPSIS2,
			])
		})
*/
	}) // JSONMap()

	/*
	describe(`MapFromJSON()`, function descMapFromJSONSuite() {
		test('should convert array to a Map', function testMapFromJSONOk() {
			const newMap = testMe.MapFromJSON([TYPE, ...mapItems])

			expect(newMap.size).toEqual(4)
			expect(newMap.has(TYPE)).toBeFalsy()
			expect(newMap.has(mapItems[0][0])).toBeTruthy()
			const values: kvPairs = []
			newMap.forEach((value, key) => values.push([key, value]))
			expect(values).toEqual(mapItems)
		})

		test('should convert array to a Map with custom ellipsis', function testMapFromJSONEllipsis() {
			const newMap = testMe.MapFromJSON(
				[TYPE, ...mapItems, ELLIPSIS2],
				ELLIPSIS2,
			)

			expect(newMap.size).toEqual(4)
			expect(newMap.has(TYPE)).toBeFalsy()
			expect(newMap.has(mapItems[0][0])).toBeTruthy()
			const values: kvPairs = []
			newMap.forEach((value, key) => values.push([key, value]))
			expect(values).toEqual(mapItems)
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
*/
})
