import { describe, expect, test, afterEach } from '@jest/globals'
import * as testMe from '../JSONDate'

const displayName = 'JSONDate'

interface TimeData {
	locale: string
	today: string
	utc: string
	epoch: number
	time: string
	localeDateTime: string
}
type TZOTimeData = Record<string, TimeData>

// NOTE: these tests may fail due to a change of time zone or daylight savings.
// and can be corrected by adding appropriate entries below for new time zones.
const TZ = process.env.TZ ?? 'Europe/London'
// const TZ = (process && process.env && process.env.TZ) || 'Europe/London'
const TZO = `${TZ}/${new Date().getTimezoneOffset()}`
const RESULTS: TZOTimeData = {
	'Europe/London/0': {
		locale: 'en-GB',
		today: '2023-02-22T16:51:48.820Z',
		utc: 'Wed, 22 Feb 2023 16:51:48 GMT',
		epoch: 1677084708820,
		time: '16:51:48 GMT+0000 (Greenwich Mean Time)',
		localeDateTime: '22/02/2023, 16:51:48',
	},
}

describe(`${displayName} module tests TZO=${TZO}`, function descJSONDateSuite() {
	const TYPE = testMe.displayName
	const reDate = /^"?[-0-9]+T[.:0-9]+Z"?$/
	const TODAY = RESULTS[TZO].today
	const date = new Date(TODAY)
	const saveIntl = Intl

	afterEach(function tearDownTests() {
		global.Intl = saveIntl
	})

	describe(`${displayName}()`, function descJSONDateSuite() {
		test('JSON.stringify does handle Date objects as string value', function testJSONStringifyDate() {
			const got = JSON.stringify(new Date())
			expect(got).toMatch(reDate) // somewhat useful but not as reversable or useful for debugging logs
		})

		test('should serialise to array', function testJSONDateDefault() {
			expect(testMe.JSONDate(date)).toEqual([
				TYPE,
				TODAY, // toJSON (english)
				{
					utc: RESULTS[TZO].utc, // toUTCString (english)
					epoch: RESULTS[TZO].epoch, // getTime/valueOf
					timeFormatted: RESULTS[TZO].time, // toTimeString (locale, but english)
					localeFormatted: RESULTS[TZO].localeDateTime, // toLocaleString (locale, may be foreign language)
					// locale information from Intl.DateFormat.resolvedOptions
					calendar: 'gregory',
					day: '2-digit',
					locale: RESULTS[TZO].locale,
					month: '2-digit',
					numberingSystem: 'latn',
					timeZone: TZ,
					year: 'numeric',
				},
			])
		})

		test('should omit locale info if not available', function testJSONDateNoLocale() {
			// @ts-expect-error The operand of a 'delete' operator must be optional.ts(2790)
			delete global.Intl
			expect(testMe.JSONDate(date)).toEqual([
				TYPE,
				TODAY, // toJSON (english)
				{
					utc: RESULTS[TZO].utc, // toUTCString (english)
					epoch: RESULTS[TZO].epoch, // getTime/valueOf
					timeFormatted: RESULTS[TZO].time, // toTimeString (locale, but english)
					localeFormatted: RESULTS[TZO].localeDateTime, // toLocaleString (locale, may be foreign language)
				},
			])
		})
	})

	describe(`DateFromJSON()`, function descDateFromJSONSuite() {
		test('should convert array to Date', function testDateFromJSONOk() {
			const newDate = testMe.DateFromJSON([TYPE, TODAY])

			expect(newDate.toJSON()).toBe(TODAY)
			expect(newDate.toLocaleString()).toBe(RESULTS[TZO].localeDateTime)
		})

		test('should convert array to an empty Date', function testDateFromJSONEmpty() {
			const newDate = testMe.DateFromJSON([TYPE])

			expect(newDate.toJSON()).toMatch(reDate)
		})

		test('should throw when array is not an object:JSONDate', function testDateFromJSONError() {
			expect(() =>
				testMe.DateFromJSON(['wrong', 'something', {}]),
			).toThrowError(
				new TypeError(
					`Cannot construct a Date from non-JSONDateish, first element of array must be '${TYPE}'. (Found 'wrong')`,
				),
			)
		})
	})
})

/*

Am trying to cover a test case where the browser does not have Intl.DateTimeFormat support.
And I'm getting typescript typing errors which I don't understand how to fix.
(I'm pretty new to Typescript but old hat on mocking and testing.)

see @ts-expect-error marker in the code below.

My library versions in use:
"typescript": "^4.9.5"
"ts-jest": "^29.0.5",
"@jest/globals": "^29.4.3",
"jest-junit": "^15.0.0",

The code being tested:

export type TimeLocale = Partial<Intl.ResolvedDateTimeFormatOptions>
export interface TimeDebug extends TimeLocale {
	utc?: string
	epoch?: number
	timeFormatted?: string
	localeFormatted?: string
}
export type JSONDateish = [
	string, // object:JSONDate
	string?, // toJSON time
	TimeDebug?,
]

export function JSONDate(date: Date): JSONDateish {
	let locale: TimeDebug = {}
	try {
		const dateFormat = new Intl.DateTimeFormat()
		locale = { ...dateFormat.resolvedOptions() }
	} catch (failure) {
		locale = {}
	} finally {
		locale.utc = date.toUTCString()
		locale.epoch = date.getTime()
		locale.timeFormatted = date.toTimeString()
		locale.localeFormatted = date.toLocaleString()
	}
	return ['object:JSONDate', date.toJSON(), locale]
}

And the test in question:

import { MockInstance } from 'jest-mock'
import { jest, describe, expect, test, afterEach } from '@jest/globals'

describe("test how to fix typings with mock functions", function descJSONDateSuite() {
	let mock: MockInstance | undefined

	afterEach(function tearDownTests() {
		if (mock) {
			mock.mockRestore()
		}
		mock = void 0
	})

	test('should omit locale info if not available', function testJSONDateNoLocale() {
		mock = jest
			.spyOn(Intl, 'DateTimeFormat')
			// @ts-expect-error Argument of type '() => never' is not assignable to parameter of type 'DateTimeFormat'.
			.mockReturnValue(() => {
				throw new ReferenceError('Intl is not defined')
			})
		expect(JSONDate(new Date())).toEqual([])
	})
})

I could also do this with a different typing error:

	const saveIntl = Intl
	afterEach(function tearDownTests() {
		global.Intl = saveIntl
	})

	test('should omit locale info if not available', function testJSONDateNoLocale() {
		// @ts-expect-error The operand of a 'delete' operator must be optional.ts(2790)
		delete global.Intl

*/
