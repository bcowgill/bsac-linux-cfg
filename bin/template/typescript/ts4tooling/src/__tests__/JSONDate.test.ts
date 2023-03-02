import { MockInstance } from 'jest-mock'
import { jest, describe, expect, test, afterEach } from '@jest/globals'
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

// MUSTDO additional time zone test for 6 months different using timemachine.

describe(`${displayName} module tests TZO=${TZO}`, function descJSONDateSuite() {
	const TYPE = testMe.displayName
	const reDate = /^"?[-0-9]+T[.:0-9]+Z"?$/
	const TODAY = RESULTS[TZO].today
	const JTODAY = '🕔' + TODAY
	const date = new Date(TODAY)

	let mock: MockInstance | undefined

	afterEach(function tearDownTests() {
		if (mock) {
			mock.mockRestore()
		}
		mock = void 0
	})

	describe('getClock()', function descGetClockSuite() {
		test('should return a clock character for the hour and half-hour', function testGetClockHourly() {
			expect(testMe.getClock()).toBe('🕛')
			expect(testMe.getClock(1)).toBe('🕐')
			expect(testMe.getClock(12, 30)).toBe('🕧')
			expect(testMe.getClock(1, 30)).toBe('🕜')
			expect(testMe.getClock(12, 44)).toBe('🕧')
			expect(testMe.getClock(12, 45)).toBe('🕐')
			expect(testMe.getClock(12, 46)).toBe('🕐')
			expect(testMe.getClock(1, 14)).toBe('🕐')
			expect(testMe.getClock(1, 15)).toBe('🕜')
			expect(testMe.getClock(1, 16)).toBe('🕜')
		})
	})

	describe(`${displayName}()`, function descJSONDateSuite() {
		test('should serialise to array', function testJSONDateDefault() {
			const json = testMe.JSONDate(date)
			expect(json).toEqual([
				TYPE,
				JTODAY, // toJSON (english)
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
			mock = jest.spyOn(Intl, 'DateTimeFormat').mockImplementation(() => {
				throw new ReferenceError('Intl is not defined')
			})
			expect(testMe.JSONDate(date)).toEqual([
				TYPE,
				JTODAY, // toJSON (english)
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
			const newDate = testMe.DateFromJSON([TYPE, JTODAY])

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
