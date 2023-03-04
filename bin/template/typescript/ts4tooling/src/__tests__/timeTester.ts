// timeTester.js
// A tool for performing date / time related tests with fixed dates so that
// time zone and daylight savings time does not cause test failures every 6 months

// MUSTDO two functions toErrorString(context, unknown): string, throwThisError(context, unknown): Error
// for catch(exception: unknown) => to log the error string w/o TS complaint
// to rethrow the error or wrap something else into an error with a context message.

import replace from 'lodash/replace'
import timeMachine from 'timemachine'
import isUndefined from 'lodash/isUndefined'
import { toErrorString, throwAsError } from '../errors'

type fnTestCase = () => void
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

export interface TimeTester {
	timeZone: string
	debugInfo(message: string): void
	TZ(date: Date, key: string): string
	replaceShortTimeZoneNames(text: string): string
	insertDate(text: string, key: string, date?: Date): string
	insertDates(template: string, date: Date): string

	// MUSTDO .test .only .fit .xit ??
	it: {
		(title1: string, fnTest: fnTestCase): void
		(title2: string, config: TimeMachineOptions, fnTest: fnTestCase): void
		skip(
			title3: string,
			config: TimeMachineOptions,
			fnTest: fnTestCase,
		): void
	}

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
}

/*
	Example of how to perform time related tests so that different time zones
	are checked against different expected test data.

	Note, on windows to test alternate time zones you have to manually change
	your time zone in control panel / Date and Time then change the Europe/London
	DEFAULT_ZONE string in timeTest.js manually to the matching unix time zone TZ name

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

// eslint-disable-next-line no-console
const log = console.error

// use a name of UTC on Jenkins linux machine
// use Europe/London on windows machines as summer time in use
const DEFAULT_ZONE = process.platform === 'win32' ? 'Europe/London' : 'UTC'

// Use this to test other time zone locally on windows
// because TZ env variable does not work.
// Set your control panel date to Pacific time also.
// const DEFAULT_ZONE = 'America/Vancouver';

// Map short linux time zone names to longer Windows ones for unit test uniformity.
const timeZoneMap: TimeStrings = {
	'(GMT)': '(GMT Standard Time)',
	'(UTC)': '(GMT Standard Time)',
	'(BST)': '(British Summer Time)',
	'(PST)': '(Pacific Standard Time)',
	'(PDT)': '(Pacific Daylight Time)',
	'(GMT Daylight Time)': '(British Summer Time)',
	'(Coordinated Universal Time)': '(GMT Standard Time)',
	// '(GMT Standard Time)': '(UTC)',
	// '(British Summer Time)': '(BST)',
	// '(Pacific Standard Time)': '(PST)',
	// '(Pacific Daylight Time)': '(PDT)',
}

function replaceShortTimeZoneNames(text: string): string {
	const reTimeZone = /(\([^)]+\))/g
	// log('replaceShortTimeZoneNames', text);
	const replaced = replace(
		text,
		reTimeZone,
		function replaceTimeZoneToken(
			placeholder: string,
			token: string,
		): string {
			// log('replaceShortTimeZoneNames', token, timeZoneMap[token]);
			return timeZoneMap[token] ?? token
		},
	)
	/* eslint-enable prefer-arrow-callback */
	return replaced
}

export default function makeTimeTester(timeZoneInfo: TimeZoneInfo): TimeTester {
	const timeZone = process.env.TZ ?? DEFAULT_ZONE
	const timeTester = {
		timeZone,
		debugInfo(message: string): void {
			const date = new Date()
			log(`timeTest debugInfo from ${message}`)
			log('process.platform', process.platform)
			log('process.env.TZ', process.env.TZ)
			log('system TZ=', timeZone)
			log('Date valueOf           ', date.valueOf())
			log('Date toString          ', date.toString())
			log('Date getTimezoneOffset ', date.getTimezoneOffset())
			// log('Date getTimezoneName', date.getTimezoneName());
			// log('Date toDateString      ', date.toDateString());
			// log('Date toTimeString      ', date.toTimeString());
			log('Date toISOString       ', date.toISOString())
			// log('Date toJSON            ', date.toJSON());
			// log('Date toGMTString       ', date.toGMTString());
			// log('Date toUTCString       ', date.toUTCString());
			// log('Date toLocaleString    ', date.toLocaleString());
			// log('Date toLocaleDateString', date.toLocaleDateString());
			// log('Date toLocaleTimeString', date.toLocaleTimeString());
		},

		TZ(date: Date, key: string): string {
			const offset = date.getTimezoneOffset()
			const zone = timeZoneInfo[timeZone]
			if (typeof zone !== 'string') {
				const savings = zone[offset]
				if (savings && !isUndefined(savings[key])) {
					return savings[key]
				}
			}
			throw new Error(
				`timeZoneInfo[${timeZone}][${offset}].${key} is not configured with test data.`,
			)
		},

		replaceShortTimeZoneNames,
		insertDate(text: string, key: string, date = new Date()): string {
			const regex = new RegExp(`%${key}%`, 'g')
			return replace(text, regex, timeTester.TZ(date, key))
		},

		insertDates(template: string, date = new Date()): string {
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
						return timeTester.TZ(date, token)
					} catch (error: unknown) {
						errorTokens.push(token)
						return `\n<< ${toErrorString('', error)} >>`
					}
				},
			)
			if (errorTokens.length) {
				const markers = `%${errorTokens.join('%, %')}%`
				throw new Error(
					`Expected test template is missing time zone specific data.\nmarkers: ${markers}\n${replaced}`,
				)
			}
			// log('insertDates 1', replaced);
			replaced = replaceShortTimeZoneNames(replaced)
			// log('insertDates 2', replaced);
			return replaced
		},

		it(
			title: string,
			config: TimeMachineOptions | fnTestCase,
			fnTest?: fnTestCase,
		): void {
			it(title, () => {
				let thisError: unknown

				/* eslint-disable no-param-reassign */
				if (!fnTest) {
					fnTest = config
					config = {}
				}
				/* eslint-enable no-param-reassign */

				// log('timeTest CONFIG', config);
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
		},

		async: {
			it(
				title: string,
				config: TimeMachineOptions | fnTestCase,
				fnTest?: fnTestCase,
			) {
				it(title, (asyncDone) => {
					let thisError: unknown

					/* eslint-disable no-param-reassign */
					if (!fnTest) {
						fnTest = config
						config = {}
					}
					/* eslint-enable no-param-reassign */

					// log('timeTest CONFIG', config);
					timeMachine.config(config)
					try {
						fnTest()
					} catch (failure) {
						thisError = failure
					} finally {
						timeMachine.reset()
						timeMachine.config({})
					}
					if (thisError) {
						throw throwAsError(thisError)
					}
					asyncDone()
				})
			},
		},
	}
	timeTester.it.skip = function timeTestSkip(
		title: string,
		unusedConfig: TimeMachineOptions,
		fnTest: fnTestCase,
	) {
		it.skip(title, fnTest)
	}
	timeTester.async.it.skip = timeTester.it.skip
	return timeTester
}
