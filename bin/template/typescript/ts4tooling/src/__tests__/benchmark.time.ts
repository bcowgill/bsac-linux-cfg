// A Typescript benchmarking test to run under Jest with npm run benchmark
import { describe } from '@jest/globals'
import timeThese, { BenchmarkSuite } from './time-these'

/*
	Typescript:
		RegExp#test x 27,206,605 ops/sec ±7.92% (69 runs sampled)
		String#indexOf x 799,105,066 ops/sec ±3.47% (86 runs sampled)
		Fastest is String#indexOf, 29.37 times faster than RegExp#test

	Javascript:
		> F=src/__tests__/benchmark.time.js; vim $F; node $F
		RegExp#test x 31,581,135 ops/sec ±5.13% (76 runs sampled)
		String#indexOf x 834,388,027 ops/sec ±3.07% (91 runs sampled)
		Fastest is String#indexOf

		no noticable difference
*/

/* eslint-disable @typescript-eslint/prefer-includes */

const Tests: BenchmarkSuite = {
	fastest: 'String#includes',
	slowest: 'String#RegExp',
	fasterBy: 25,
	exceedsHz: 60e7,
	implementations: [
		[
			'RegExp#test',
			function testRegExp() {
				;/o/.test('Hello World!')
			},
		],
		/*['String#indexOf', function testStringIndexOf() {
			'Hello World!'.indexOf('o') > -1
		}], */ [
			'String#includes',
			function testStringIncludes() {
				'Hello World!'.includes('o')
			},
		],
	],
}

describe('time-these suite', function descTimeTheseSuite() {
	timeThese(Tests)
})
