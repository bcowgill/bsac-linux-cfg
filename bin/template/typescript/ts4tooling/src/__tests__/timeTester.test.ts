import { describe, expect } from '@jest/globals'
import makeTimeTester, { TimeZoneInfo, TimeMachineOptions } from './timeTester'

// does not know about timeTest.it...
/* eslint-disable jest/no-standalone-expect */

const displayName = 'timeTester'

describe(`${displayName} module tests`, function descTimeTesterSuite() {
	const TEST_SUMMER_TIME = 'July 22, 1991 12:13:59'
	const TEST_TIME = 'December 25, 1991 12:12:59 GMT'

	const timeZoneMap = {
		'(Greenwich Mean Time)': '(GMT)',
		'(GMT Standard Time)': '(GMT)',
		'(British Summer Time)': '(BST)',
		'(Pacific Standard Time)': '(PST)',
		'(Pacific Daylight Time)': '(PDT)',
		'(Coordinated Universal Time)': '(UTC)',
	}

	const timeZoneInfo: TimeZoneInfo = {
		// You should test with at least two dates 6 months apart
		TEST_TIME,
		TEST_SUMMER_TIME,
		// UTC time is most likely used when your CI build runs on a virtual machine
		UTC: {
			0: {
				VALUE: '680184839000',
				VALUE_WINTER: '693663179000',
				SUMMER_LOC_DATE: '22/07/1991',
				WINTER_LOC_DATE: '25/12/1991',
				SUMMER_ZONE: '(UTC)',
				WINTER_ZONE: '(UTC)',
				SUMMER_ZONE_LONG: '(GMT Standard Time)',
				WINTER_ZONE_LONG: '(GMT Standard Time)',
				SUMMER_toString:
					'Mon Jul 22 1991 12:13:59 GMT+0000 (Coordinated Universal Time)',
				WINTER_toString:
					'Wed Dec 25 1991 12:12:59 GMT+0000 (Coordinated Universal Time)',
			},
		},
		// Test in your local time zone when running locally
		'Europe/London': {
			0: {
				VALUE_WINTER: '693663179000',
				WINTER_LOC_DATE: '25/12/1991',
				WINTER_ZONE: '(GMT)',
				WINTER_ZONE_LONG: '(GMT Standard Time)',
				WINTER_toString:
					'Wed Dec 25 1991 12:12:59 GMT+0000 (Greenwich Mean Time)',
			},
			'-60': {
				VALUE: '680181239000',
				SUMMER_LOC_DATE: '22/07/1991',
				SUMMER_ZONE: '(BST)',
				SUMMER_ZONE_LONG: '(British Summer Time)',
				SUMMER_toString:
					'Mon Jul 22 1991 12:13:59 GMT+0100 (British Summer Time)',
			},
		},
		// A secondary time zone you can test using export TZ=America/Vancouver before running the tests.
		'America/Vancouver': {
			480: {
				VALUE_WINTER: '693663179000',
				WINTER_LOC_DATE: '25/12/1991',
				WINTER_ZONE: '(PST)',
				WINTER_ZONE_LONG: '(Pacific Standard Time)',
				WINTER_toString:
					'Wed Dec 25 1991 04:12:59 GMT-0800 (Pacific Standard Time)',
			},
			420: {
				VALUE: '680210039000',
				SUMMER_LOC_DATE: '22/07/1991',
				SUMMER_ZONE: '(PDT)',
				SUMMER_ZONE_LONG: '(Pacific Daylight Time)',
				SUMMER_toString:
					'Mon Jul 22 1991 12:13:59 GMT-0700 (Pacific Daylight Time)',
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
			expect(now).toBe(Number(timeTest.TZ('VALUE')))
		},
	)

	timeTest.it(
		'should pass in WINTER time',
		WINTER,
		function testWinterTime() {
			const expected = timeTest.TZ('VALUE_WINTER')
			timeTest.debugInfo(displayName)

			const now = Date.now()
			expect(now).toBe(Number(expected))
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
					const expected = timeTest.TZ(`${timeName}_toString`, now)

					expect(now.toString()).toBe(expected)
				},
			)
			timeTest.it(
				`timeTest.replaceShortTimeZoneNames() should provide uniformity of time zone names across OS's`,
				fakeTime,
				function testReplaceShortTimeZoneNames() {
					// Date .toString() has a time zone string that varies across browser/node/os versions.
					// Older nodejs uses short (GMT) strings.
					// Windows uses longer (GMT Standard Time) strings
					// Newer nodejs uses longer, (Greenwich Mean Time) different strings
					// so replaceShortTimeZoneNames() exists to replace these strings for unified tests across your technology
					const expectZone = timeTest.TZ(`${timeName}_ZONE_LONG`)
					const expected = `[${expectZone}] (not a time zone) (GMT Standard Time) (GMT Standard Time) (British Summer Time) (Pacific Standard Time) (Pacific Daylight Time) (GMT Standard Time) (British Summer Time) (GMT Standard Time)`

					const now = new Date()
					const zone = now.toString().replace(/^.*\(/, '(')
					const actual = `[${zone}] (not a time zone) (GMT) (UTC) (BST) (PST) (PDT) (Greenwich Mean Time) (GMT Daylight Time) (Coordinated Universal Time)`

					expect(timeTest.replaceShortTimeZoneNames(actual)).toBe(
						expected,
					)
				},
			)
			timeTest.it(
				`timeTest.replaceShortTimeZoneNames(custom tzMap) should provide uniformity of time zone names across OS's`,
				fakeTime,
				function testReplaceShortTimeZoneNamesCustom() {
					const expectZone = timeTest.TZ(`${timeName}_ZONE`)
					const expected = `[${expectZone}] (not a time zone) (GMT) (GMT) (BST) (PST) (PDT) (GMT) (BST) (GMT)`

					const now = new Date()
					const zone = now.toString().replace(/^.*\(/, '(')
					const actual = `[${zone}] (not a time zone) (GMT Standard Time) (GMT Standard Time) (British Summer Time) (Pacific Standard Time) (Pacific Daylight Time) (GMT Standard Time) (British Summer Time) (GMT Standard Time)`

					expect(
						timeTest.replaceShortTimeZoneNames(actual, timeZoneMap),
					).toBe(expected)
				},
			)
			timeTest.it(
				`timeTest.insertDate() should provide testing of dates within other strings`,
				fakeTime,
				function testInsertDate() {
					const expected = timeTest.insertDate(
						`Your card expires %${timeName}_LOC_DATE%, please renew it before then.`,
						`${timeName}_LOC_DATE`,
					)

					const now = new Date()
					const actual = `Your card expires ${now.toLocaleDateString()}, please renew it before then.`

					expect(actual).toBe(expected)
				},
			)
			timeTest.it(
				`timeTest.insertDates() should provide testing of dates within other strings`,
				fakeTime,
				function testInsertDates() {
					const expected = timeTest.insertDates(
						`[%${timeName}_toString%] Your card expires %${timeName}_LOC_DATE%, please renew it before then.`,
					)

					const now = new Date()
					const actual = `[${now.toString()}] Your card expires ${now.toLocaleDateString()}, please renew it before then.`

					expect(timeTest.replaceShortTimeZoneNames(actual)).toBe(
						expected,
					)
				},
			)
		})
	})
})
