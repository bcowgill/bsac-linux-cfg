import { describe, expect } from '@jest/globals'
import makeTimeTester, { TimeZoneInfo, TimeMachineOptions } from './timeTester'

// does not know about timeTest.it...
/* eslint-disable jest/no-standalone-expect */

const displayName = 'timeTester'

describe(`${displayName} module tests`, function descTimeTesterSuite() {
	const TEST_SUMMER_TIME = 'July 22, 1991 12:13:59'
	const TEST_TIME = 'December 25, 1991 12:12:59 GMT'

	const timeZoneInfo: TimeZoneInfo = {
		// You should test with at least two dates 6 months apart
		TEST_TIME,
		TEST_SUMMER_TIME,
		'Europe/London': {
			0: {
				LOC_DATE: '25/12/1991',
				toString:
					'Wed Dec 25 1991 12:12:59 GMT+0000 (Greenwich Mean Time)',
			},
			'-60': {
				LOC_DATE: '22/07/1991',
				toString:
					'Mon Jul 22 1991 12:13:59 GMT+0100 (British Summer Time)',
			},
		},
	}

	// See npm module timemachine for config options
	const WINTER: TimeMachineOptions = { dateString: TEST_TIME }
	const SUMMER: TimeMachineOptions = { dateString: TEST_SUMMER_TIME }
	const TIMES = { SUMMER, WINTER }

	const timeTest = makeTimeTester(timeZoneInfo)

	timeTest.test(
		'should pass in SUMMER time',
		SUMMER,
		function testSummerTime() {
			timeTest.debugInfo(displayName)
			const now = Date.now()
			expect(now).toBe(680181239000)
		},
	)

	timeTest.it(
		'should pass in WINTER time',
		WINTER,
		function testWinterTime() {
			timeTest.debugInfo(displayName)
			const now = Date.now()
			expect(now).toBe(693663179000)
		},
	)

	Object.keys(TIMES).forEach(function forEachTestTime(timeName) {
		const fakeTime = TIMES[timeName] as TimeMachineOptions
		describe(`test during ${timeName} time ${fakeTime.dateString ?? '<MISSING>'}`, function descEachTimeSuite() {
			timeTest.it(
				`timeTest.TZ() should provide access to time-specific values in tests`,
				fakeTime,
				function testTZ() {
					const now = new Date()
					expect(now.toString()).toBe(timeTest.TZ('toString', now))
				},
			)
			timeTest.it(
				`timeTest.replaceShortTimeZoneNames() should provide uniformity of time zone names across OS's`,
				fakeTime,
				function testReplaceShortTimeZoneNames() {
					const now = new Date()
					// Date .toString() has a time zone string that varies across OS platforms.
					// Linux uses short (GMT) strings.
					// Windows uses longer (GMT Standard Time) strings
					// Mac uses longer, (Greenwich Mean Time) different strings
					// so replaceShortTimeZoneNames() exists to replace these strings for unified tests across OSes
					const zone = now.toString().replace(/^.*\(/, '(')
					const expectZone = now.getTimezoneOffset()
						? '(British Summer Time)'
						: '(GMT Standard Time)'
					const expected = `[${expectZone}] (not a time zone) (GMT Standard Time) (GMT Standard Time) (British Summer Time) (Pacific Standard Time) (Pacific Daylight Time) (GMT Standard Time) (British Summer Time) (GMT Standard Time)`
					const actual = `[${zone}] (not a time zone) (GMT) (UTC) (BST) (PST) (PDT) (Greenwich Mean Time) (GMT Daylight Time) (Coordinated Universal Time)`
					expect(timeTest.replaceShortTimeZoneNames(actual)).toBe(
						expected,
					)
				},
			)
			timeTest.it(
				`timeTest.insertDate() should provide testing of dates within other strings`,
				fakeTime,
				function testInsertDate() {
					const now = new Date()
					const actual = `Your card expires ${now.toLocaleDateString()}, please renew it before then.`
					const expected = timeTest.insertDate(
						'Your card expires %LOC_DATE%, please renew it before then.',
						'LOC_DATE',
					)
					expect(actual).toBe(expected)
				},
			)
			timeTest.it(
				`timeTest.insertDates() should provide testing of dates within other strings`,
				fakeTime,
				function testInsertDates() {
					const now = new Date()
					const actual = `[${now.toString()}] Your card expires ${now.toLocaleDateString()}, please renew it before then.`
					const expected = timeTest.insertDates(
						'[%toString%] Your card expires %LOC_DATE%, please renew it before then.',
					)
					expect(timeTest.replaceShortTimeZoneNames(actual)).toBe(
						expected,
					)
				},
			)
		})
	})
})
