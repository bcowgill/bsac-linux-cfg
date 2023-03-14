// timeTester.js
// A tool for performing date / time related tests with fixed dates so that
// time zone and daylight savings time does not cause test failures every 6 months

/// <reference types="@jest/types" />

import replace from 'lodash/replace'
import timeMachine from 'timemachine'
import isUndefined from 'lodash/isUndefined'
import { toErrorString, throwAsError } from '../errors'

const displayName = 'timeTester'

// timemachine.config() 1st parameter...
export interface TimeMachineOptions {
	dateString?: string
	timestamp?: number
	difference?: number
	tick?: boolean
	keepTime?: boolean
}

export type TimeStrings = Record<string, string | undefined>
export type TimeOffsets = Record<string | number, TimeStrings | undefined>
// export type TimeRegionInfo = Record<string, TimeOffsets | undefined>
export type TimeZoneInfo = Record<string, string | TimeOffsets | undefined>

export type TimeTestName = string
export type TimeTestConfig = TimeMachineOptions | undefined
export type TimeTestFn = jest.EmptyFunction
export type TimeTestCase = (
	name: TimeTestName,
	config: TimeTestConfig,
	fnTest: TimeTestFn,
) => void

export interface TimeTestDescribe {
	(name: TimeTestName, config: TimeTestConfig, fnTest: TimeTestFn): void
	only: TimeTestCase
	skip: TimeTestCase
}

export interface TimeTester {
	timeZone: string
	debugInfo(message: string): void
	TZ(key: string, date?: Date): string
	replaceShortTimeZoneNames(text: string, tzMap?: TimeStrings): string
	insertDate(text: string, key: string, date?: Date): string
	insertDates(template: string, date?: Date): string

	it: TimeTestDescribe
	test: TimeTestDescribe // == it
	xit: TimeTestCase // == it.skip
	fit: TimeTestCase // == it.only

	/* MUSTDO async tests
	async: {
		it: {
			(title4: string, fnTest: fnTestCase): void
			(
				title5: string,
				config: TimeMachineOptions | fnTestCase,
				fnTest?: fnTestCase,
			): void
			skip(
				title6: string,
				config: TimeMachineOptions | fnTestCase,
				fnTest?: fnTestCase,
			): void
		}
	}
	*/
} // TimeTester interface

/*
	Example of how to perform time related tests so that different time zones
	are checked against different expected test data.

	Note, on windows to test alternate time zones you have to manually change
	your time zone in control panel / Date and Time then change the Europe/London
	DEFAULT_ZONE string in timeTest.js manually to the matching unix time zone TZ name

	MUSTDO update these docs after testing complete
	const timeZoneInfo = {
		// You should test with at least two dates 6 months apart
		TEST_TIME: 'December 25, 1991 12:12:59 GMT',
		TEST_SUMMER_TIME: 'July 22, 1991 12:13:59',
		UTC: {
			// Jenkins no Daylight time
			0: {
				ISO_DATE: '1991-12-25T12:12:59.000Z',
				ISO_SUMMER_DATE: '1991-07-22T12:13:59.000Z',
				LOCAL_DATE: 'Wednesday 25 Dec 1991 12:12:59 PM (GMT Standard Time)',
				LOCAL_SUMMER_DATE: 'Monday 22 Jul 1991 12:13:59 PM (GMT Standard Time)',
			},
		},
		'Europe/London': {
			0: {
				ISO_DATE: '1991-12-25T12:12:59.000Z',
				LOCAL_DATE: 'Wednesday 25 Dec 1991 12:12:59 PM (GMT Standard Time)',
			},
			'-60': {
				ISO_SUMMER_DATE: '1991-07-22T11:13:59.000Z',
				LOCAL_SUMMER_DATE: 'Monday 22 Jul 1991 12:13:59 PM (GMT Daylight Time)',
			},
		},
		'America/Vancouver': {
			480: {
				ISO_DATE: '1991-12-25T12:12:59.000Z',
				LOCAL_DATE: 'Wednesday 25 Dec 1991 4:12:59 AM (Pacific Standard Time)',
			},
			420: {
				ISO_SUMMER_DATE: '1991-07-22T19:13:59.000Z',
				LOCAL_SUMMER_DATE:
					'Monday 22 Jul 1991 12:13:59 PM (Pacific Daylight Time)',
			},
		},
	};

	const timeTest = makeTimeTester(timeZoneInfo);

	describe ...
		timeTest.it('should perform a test with a fixed date for new Date()',
			// See npm module timemachine for config options
			{ dateString: timeZoneInfo.TEST_TIME },
			function testDateText() {
				const actual = timeTest.replaceShortTimeZoneNames(some_function_of_current_date_time());
				const expected = timeTest.insertDates(
					'Surrounding Text and %FORMATTED% date values %FORMATTED_LOCAL%');
				expect(actual).toBe(expected);
		});
*/

const messages: string[] = []
function log(...args) {
	messages.push(args.join(' '))
}
function flushLog(): void {
	// eslint-disable-next-line no-console
	console.error(messages.join('\n'))
	messages.length = 0
}
// // eslint-disable-next-line no-console
// const log = console.error
// const flushLog = () => void 0

// use a name of UTC on Jenkins linux machine
// use Europe/London on windows machines as summer time in use
const DEFAULT_ZONE = process.platform === 'win32' ? 'Europe/London' : 'UTC'

// Use this to test other time zone locally on windows
// because TZ env variable does not work.
// Set your control panel date to Pacific time also.
// const DEFAULT_ZONE = 'America/Vancouver';

// MUSTDO make it so we can pass this config in to makeTimeTester
// Map short linux time zone names to longer Windows/Mac ones for unit test uniformity.
export const timeZoneMap: TimeStrings = {
	// Linux  Windows
	'(GMT)': '(GMT Standard Time)',
	'(UTC)': '(GMT Standard Time)',
	'(BST)': '(British Summer Time)',
	'(PST)': '(Pacific Standard Time)',
	'(PDT)': '(Pacific Daylight Time)',
	// Mac                   Windows
	'(Greenwich Mean Time)': '(GMT Standard Time)',
	'(Coordinated Universal Time)': '(GMT Standard Time)',
	// Windows
	'(GMT Daylight Time)': '(British Summer Time)',
	// '(GMT Standard Time)': '(UTC)',
	// '(British Summer Time)': '(BST)',
	// '(Pacific Standard Time)': '(PST)',
	// '(Pacific Daylight Time)': '(PDT)',
}

/**
 * This replaces time zone names in one format like short (GMT) to another format like longer (GM Standard Time) according to an internal or provided time zone map object.
 * @param text string containing (GMT) and other time zone names which are OS specific.
 * @param tzMap optional object mapping time zone names like (BST) to other names like (British Summer Time) for uniformity of unit tests across operating systems.
 * @returns the string with time zone names replaced according to the tzMap.
 */
export function replaceShortTimeZoneNames(
	text: string,
	tzMap = timeZoneMap,
): string {
	const reTimeZone = /(\([^)]+\))/g
	// log(`${displayName}.replaceShortTimeZoneNames`, text);
	const replaced = replace(
		text,
		reTimeZone,
		function replaceTimeZoneToken(
			placeholder: string,
			token: string,
		): string {
			// log(`${displayName}.replaceShortTimeZoneNames`, token, tzMap[token]);
			return tzMap[token] ?? token
		},
	)
	/* eslint-enable prefer-arrow-callback */
	return replaced
}
/**
 * Creates an object to help out with testing date/time values. Before each unit test it will set the Date object's simulated date to the value given in a timemachine options structure.  It also contains functions comparing expected time strings with actual ones based on the time zone and offset.
 * @param timeZoneInfo structure containing time values for unit tests and formatted time strings indexed by time zone name and time zone offset.
 * @param tzMap optional object mapping time zone names like (BST) to other names like (British Summer Time) for uniformity of unit tests across operating systems.
 * @returns an object you can use for unit tests which need to simulate specific date/times.
 */
export default function makeTimeTester(
	timeZoneInfo: TimeZoneInfo,
	tzMap?: TimeStrings,
): TimeTester {
	const timeZone = process.env.TZ ?? DEFAULT_ZONE

	/**
	 * This runs a unit test case with the Date object set to a specific date provided by the timemachine config object provided.  If omitted the time will be zero, way back in 1970.
	 * @param fnIt The test runner function to run the test with. ie. it, it.only.
	 * @param name The name of the test to run.
	 * @param config optional. The timemachine configuration to use for this time-related test case.
	 * @param fnTest The test function itself will be run with Date object set to match the timemachine config provided.
	 */
	const timeTestCase = function (
		fnIt: jest.It,
		name: string,
		config = {},
		fnTest: TimeTestFn,
	): void {
		fnIt(name, function timeTestItInner() {
			let thisError: unknown

			// log(`${displayName}.timeTestOnly CONFIG`, config);
			timeMachine.config(config)
			try {
				fnTest()
			} catch (failure: unknown) {
				thisError = failure
			} finally {
				timeMachine.reset()
				timeMachine.config({})
			}
			if (thisError) {
				throw throwAsError(thisError)
			}
		})
	}

	const timeTestIt: TimeTestDescribe = function (name, config, fnTest) {
		timeTestCase(it, name, config, fnTest)
	}

	const timeTestOnly: TimeTestCase = function (name, config, fnTest) {
		timeTestCase(it.only, name, config, fnTest)
	}

	const timeTestSkip: TimeTestCase = function (name, config, fnTest) {
		it.skip(name, fnTest)
	}

	timeTestIt.only = timeTestOnly
	timeTestIt.skip = timeTestSkip

	const timeTester = {
		timeZone,
		/**
		 * Log a bunch of time related debugging information.
		 * @param message diagnostic string to log with the time info
		 */
		debugInfo(message: string): void {
			const date = new Date()
			let options = {}

			try {
				const dateFormat = new Intl.DateTimeFormat()
				options = dateFormat.resolvedOptions()
				// eslint-disable-next-line no-empty
			} catch (failure) {}

			log(`${displayName}.debugInfo from ${message}`)
			log('process.platform', process.platform)
			log('process.env.TZ', process.env.TZ)
			log('system TZ=', timeZone)
			log('Intl.DateTimeFormat Options=', JSON.stringify(options))
			log('Date getTimezoneOffset ', date.getTimezoneOffset())
			log('Date valueOf           ', date.valueOf())
			log('Date toString          ', date.toString())
			// log('Date toDateString      ', date.toDateString())
			// log('Date toTimeString      ', date.toTimeString())
			// log('Date toISOString       ', date.toISOString())
			log('Date toUTCString       ', date.toUTCString())
			log('Date toJSON            ', date.toJSON())
			log('Date toLocaleString    ', date.toLocaleString())
			// log('Date toLocaleDateString', date.toLocaleDateString())
			// log('Date toLocaleTimeString', date.toLocaleTimeString())
			flushLog()
		},

		/**
		 * Looks up a date/time related string value in the timeZoneInfo structure which was passed to a makeTimeTester() call given a key string and date.
		 * @param key string to look up a time specific value within the time zone offset object of a time zone name object of the timeZoneInfo structure.
		 * @param date optional date object to use time zone offset from.  Defaults to current date.
		 * @returns the string value associated with the time zone/offset and key value.
		 * @throws an Error if there is no value configured for the time zone, offset and key name provided.
		 */
		TZ(key: string, date = new Date()): string {
			const offset = date.getTimezoneOffset()
			const zone = timeZoneInfo[timeZone] ?? {}
			if (typeof zone !== 'string') {
				const savings = zone[offset]
				if (savings && !isUndefined(savings[key])) {
					// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
					return savings[key]!
				}
			}
			throw new Error(
				`${displayName} timeZoneInfo[${timeZone}][${offset}].${key} is not configured with test data.`,
			)
		},

		/**
		 * This replaces time zone names in one format like short (GMT) to another format like longer (GM Standard Time) according to an internal or provided time zone map object.
		 * @param text string containing (GMT) and other time zone names which are OS specific.
		 * @param tzMap optional object mapping time zone names like (BST) to other names like (British Summer Time) for uniformity of unit tests across operating systems.
		 * @returns the string with time zone names replaced according to the tzMap.
		 */
		replaceShortTimeZoneNames(text: string, tzMap: TimeStrings): string {
			return replaceShortTimeZoneNames(text, tzMap)
		},

		/**
		 * This will insert a time zone and offset specific string from the timeZoneInfo structure into a text string marked by %KEY% so date related unit tests can be independent of time zones where they run.
		 * @param text string containing a %KEY% marker indicating where to insert a time zone/offset specific string from the timeZoneInfo.
		 * @param key the specific KEY string to look for within the text param.
		 * @param date optional Date object to get the time zone offset from.
		 * @returns the text string with %KEY% value replaced by string from timeZoneInfo for zone and offset supplied.
		 * @throws an Error if there is no value configured for the time zone, offset and key name provided.
		 */
		insertDate(text: string, key: string, date: Date): string {
			const regex = new RegExp(`%${key}%`, 'g')
			return replace(text, regex, timeTester.TZ(key, date))
		},

		/**
		 * This will insert many time zone and offset specific strings from the timeZoneInfo structure into a text string marked by %KEY% markers so date related unit tests can be independent of time zones where they run.
		 * @param template string containing multiple %KEY% markers indicating where to insert time zone/offset specific strings from the timeZoneInfo.
		 * @param date optional Date object to get the time zone offset from.
		 * @returns the text string with %KEY% values replaced by strings from timeZoneInfo for zone and offset supplied.
		 * @throws an Error if there are missing values for the time zone, offset and key names provided in the template.
		 */
		insertDates(template: string, date: Date): string {
			const reToken = /%(\w+)%/g
			const errorTokens: string[] = []
			let replaced = replace(
				template,
				reToken,
				function replaceDateToken(
					placeholder: string,
					token: string,
				): string {
					try {
						return timeTester.TZ(token, date)
					} catch (error: unknown) {
						errorTokens.push(token)
						return `\n<< ${toErrorString('', error)} >>`
					}
				},
			)
			if (errorTokens.length) {
				const markers = `%${errorTokens.join('%, %')}%`
				throw new Error(
					`${displayName}.insertDates Expected test template is missing time zone specific data.\nmarkers: ${markers}\n${replaced}`,
				)
			}
			// log(`${displayName}.insertDates 1`, replaced);
			replaced = replaceShortTimeZoneNames(replaced, tzMap)
			// log(`${displayName}.insertDates 2`, replaced);
			return replaced
		},

		it: timeTestIt,
		test: timeTestIt,
		xit: timeTestSkip,
		fit: timeTestOnly,

		// MUSTDO async tests...
		// async: {
		// 	it(
		// 		title: string,
		// 		config: TimeMachineOptions | fnTestCase,
		// 		fnTest?: fnTestCase,
		// 	) {
		// 		it(title, (asyncDone) => {
		// 			let thisError: unknown

		// 			/* eslint-disable no-param-reassign */
		// 			if (!fnTest) {
		// 				fnTest = config
		// 				config = {}
		// 			}
		// 			/* eslint-enable no-param-reassign */

		// 			// log('timeTest CONFIG', config);
		// 			timeMachine.config(config)
		// 			try {
		// 				fnTest()
		// 			} catch (failure) {
		// 				thisError = failure
		// 			} finally {
		// 				timeMachine.reset()
		// 				timeMachine.config({})
		// 			}
		// 			if (thisError) {
		// 				throw throwAsError(thisError)
		// 			}
		// 			asyncDone()
		// 		})
		// 	},
		// },
	}

	return timeTester
}
