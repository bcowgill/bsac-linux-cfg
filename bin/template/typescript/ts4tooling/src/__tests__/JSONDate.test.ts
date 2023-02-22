import { describe, expect, test } from '@jest/globals'
import * as testMe from '../JSONDate'

const displayName = 'JSONDate'

describe(`${displayName} module tests`, function descJSONDateSuite() {
	const TYPE = testMe.displayName
	// NOTE: these tests may fail due to a change of time zone or daylight savings.
	const reDate = /^"?[-0-9]+T[.:0-9]+Z"?$/
	const TODAY = '2023-02-22T16:51:48.820Z'
	const date = new Date(TODAY)

	describe(`${displayName}()`, function descJSONDateSuite() {
		test('JSON.stringify does handle Date objects as string value', function testJSONStringifyDate() {
			const got = JSON.stringify(new Date())
			expect(got).toMatch(reDate) // somewhat useful but not as reversable or useful for debugging logs
		})

		test('should serialise to array', function testJSONDateDefault() {
			expect(testMe.JSONDate(date)).toEqual([
				TYPE,
				'2023-02-22T16:51:48.820Z', // toJSON (english)
				'Wed, 22 Feb 2023 16:51:48 GMT', // toUTCString (english)
				1677084708820, // valueOf
				'Wed[3]', // Day of week name and number
				'16:51:48 GMT+0000 (Greenwich Mean Time)', // toTimeString (locale, but english)
				'22/02/2023, 16:51:48', // toLocaleString (locale, may be foreign language)
				{
					// locale information from Intl.DateFormat.resolvedOptions
					calendar: 'gregory',
					day: '2-digit',
					locale: 'en-GB',
					month: '2-digit',
					numberingSystem: 'latn',
					timeZone: 'Europe/London',
					year: 'numeric',
				},
			])
		})
	})

	describe(`DateFromJSON()`, function descDateFromJSONSuite() {
		test('should convert array to Date', function testDateFromJSONOk() {
			const newDate = testMe.DateFromJSON([TYPE, TODAY])

			expect(newDate.toJSON()).toBe(TODAY)
			expect(newDate.toLocaleString()).toBe('22/02/2023, 16:51:48')
		})

		test('should convert array to an empty Date', function testDateFromJSONEmpty() {
			const newDate = testMe.DateFromJSON([TYPE])

			expect(newDate.toJSON()).toMatch(reDate)
		})

		test('should throw when array is not an object:JSONDate', function testDateFromJSONError() {
			expect(() =>
				testMe.DateFromJSON(['wrong', 'something', 'ig']),
			).toThrowError(
				new TypeError(
					`Cannot construct a Date from non-JSONDateish, first element of array must be '${TYPE}'. (Found 'wrong')`,
				),
			)
		})
	})
})
