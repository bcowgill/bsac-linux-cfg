import { describe, expect, test } from '@jest/globals'
import * as testMe from '../JSONRegExp'

const displayName = 'JSONRegExp'

describe(`${displayName} module tests`, function descJSONRegExpSuite() {
	const TYPE = testMe.displayName
	const regex = /^this is the source$/gimuy
	const sampleText = 'thIs is tHe sOurce'

	describe(`${displayName}()`, function descJSONRegExpSuite() {
		test('JSON.stringify does not handle RegExp objects', function testJSONStringifyRegExp() {
			const got = JSON.stringify(/^this$/i)
			expect(got).toBe('{}') // Not very useful
		})

		test('should serialise to array', function testJSONRegExpDefault() {
			expect(sampleText).toMatch(regex)
			expect(testMe.JSONRegExp(regex)).toEqual([
				TYPE,
				'^this is the source$',
				'gimuy',
			])
		})
	})

	describe(`RegExpFromJSON()`, function descRegExpFromJSONSuite() {
		test('should convert array to RegExp', function testRegExpFromJSONOk() {
			const newRegex = testMe.RegExpFromJSON([
				TYPE,
				'^this is the source$',
				'gi',
			])

			expect(sampleText).toMatch(newRegex)
			expect(newRegex.toLocaleString()).toBe('/^this is the source$/gi')
			expect(newRegex.source).toEqual('^this is the source$')
			expect(newRegex.flags).toEqual('gi')
		})

		test('should convert array to an empty RegExp', function testRegExpFromJSONEmpty() {
			const newRegex = testMe.RegExpFromJSON([TYPE])

			expect(sampleText).toMatch(newRegex)
			expect(newRegex.source).toEqual('(?:)')
			expect(newRegex.flags).toEqual('')
		})

		test('should throw when array is not an object:JSONRegExp', function testRegExpFromJSONError() {
			expect(() =>
				testMe.RegExpFromJSON(['wrong', 'something', 'ig']),
			).toThrowError(
				new TypeError(
					`Cannot construct a RegExp from non-JSONRegExpish, first element of array must be '${TYPE}'. (Found 'wrong')`,
				),
			)
		})
	})
})
