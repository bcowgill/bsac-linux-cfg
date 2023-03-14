import { describe, expect } from '@jest/globals'
import makeTimeTester, { TimeZoneInfo, TimeMachineOptions } from './timeTester'

// does not know about timeTest.it...
/* eslint-disable jest/no-standalone-expect */

const displayName = 'timeTester.only'

describe.skip(`${displayName} module tests`, function descTimeTesterSuite() {
	const TEST_TIME = 'December 25, 1991 12:12:59 GMT'

	const timeZoneInfo: TimeZoneInfo = {
		// You should test with at least two dates 6 months apart
		TEST_TIME,
	}

	// See npm module timemachine for config options
	const WINTER: TimeMachineOptions = { dateString: TEST_TIME }

	const timeTest = makeTimeTester(timeZoneInfo)

	timeTest.it.only(
		'it.only() - should pass in WINTER time (covereage)',
		WINTER,
		function testWinterTimeOnly1() {
			const now = Date.now()
			expect(now).toBe(693663179000)
		},
	)

	timeTest.fit(
		'fit() - should pass in WINTER time only (covereage)',
		WINTER,
		function testWinterTimeOnly2() {
			const now = Date.now()
			expect(now).toBe(693663179000)
		},
	)

	timeTest.fit(
		'fit(no config) - should pass using 0 point (covereage)',
		void 0,
		function testRealTimeOnly3() {
			const now = Date.now()
			expect(now).toBe(0)
		},
	)

	timeTest.fit(
		'TZ() should throw for missing timeZoneInfo in WINTER time only (covereage)',
		WINTER,
		function testWinterTimeTZThrows() {
			const now = new Date()
			expect(now.toString()).toBe(timeTest.TZ('MISSING_KEY'))
		},
	)

	timeTest.fit(
		'insertDates() should throw for missing timeZoneInfo in WINTER time only (covereage)',
		WINTER,
		function testWinterTimeInsertDatesThrows() {
			const expected = `[%NOT_PRESENT%]<%MISSING%>`

			const now = new Date()
			const actual = `[${now.toJSON()}]<${now.getDate()}>`

			expect(actual).toBe(timeTest.insertDates(expected))
		},
	)

	timeTest.it.skip(
		'it.skip() should skip this one (covereage)',
		WINTER,
		function testWinterTimeSkip1() {
			expect(false).toBe(true)
		},
	)

	timeTest.xit(
		'xit() - should skip this one too (covereage)',
		WINTER,
		function testWinterTimeSkip2() {
			expect(false).toBe(true)
		},
	)
})
