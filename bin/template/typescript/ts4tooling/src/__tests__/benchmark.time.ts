// A Typescript benchmarking test to run under Jest with npm run benchmark
import Benchmark, { Suite, Event } from 'benchmark'
import { describe, expect, test } from '@jest/globals'
/* eslint-disable @typescript-eslint/prefer-includes */

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

type Implementation = [string, () => void]

interface BenchmarkSuite {
	verbose?: boolean
	debug?: boolean
	fastest: string
	slowest: string
	fasterBy?: number
	exceedsHz?: number
	implementations: Implementation[]
}

const Tests: BenchmarkSuite = {
	fastest: 'String#includes',
	slowest: 'String#RegExp',
	fasterBy: 25,
	exceedsHz: 785860200,
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

describe('benchmark suite', function descBenchmarkSuite() {
	const FASTEST = Tests.fastest
	const SLOWEST = Tests.slowest
	const SPEEDY = Tests.fasterBy
	const THRESHOLD = Tests.exceedsHz

	let explanation = 'faster than'
	if (SPEEDY) {
		explanation = `${SPEEDY}x faster than`
	} else if (THRESHOLD) {
		explanation = `at least ${THRESHOLD} Hz and faster than`
	}
	test(`${FASTEST} should be ${explanation} ${SLOWEST}`, function asyncTestRegexVsIndexOfVsIncludes(fnDone) {
		const suite: Suite = new Benchmark.Suite()
		const results: string[] = []
		const timings: number[] = []

		Tests.implementations.forEach(function addTests([name, fnTest]) {
			suite.add(name, fnTest)
		})
		// add listeners
		suite
			.on('cycle', function (event: Event) {
				// console.warn('cycle', event.target.name, event.target.hz)
				results.push(String(event.target))
				timings.push(event.target.hz ?? 0)
			})
			.on('complete', function (this: Suite) {
				if (Tests.debug) {
					// eslint-disable-next-line no-console
					console.warn(
						'FILTERED',
						// eslint-disable-next-line @typescript-eslint/no-unsafe-argument, @typescript-eslint/no-unsafe-return
						...this.filter('fastest').map((x) => x),
					)
				}
				const fastest: string = this.filter('fastest').map(
					'name',
				)[0] as typeof Benchmark.name
				const slowest: string = this.filter('slowest').map(
					'name',
				)[0] as typeof Benchmark.name
				const bestRate = Math.max(...timings)
				const fasterThan =
					Math.floor((100 * bestRate) / Math.min(...timings)) / 100
				results.push(
					`Fastest is ${fastest}, ${fasterThan} times faster than ${slowest}`,
				)
				if (Tests.verbose) {
					// eslint-disable-next-line no-console
					console.log(results.join('\n'))
				}

				try {
					expect(fastest).toBe(FASTEST)
					if (THRESHOLD) {
						expect(bestRate).toBeGreaterThanOrEqual(THRESHOLD)
					}
					if (SPEEDY) {
						expect(fasterThan).toBeGreaterThanOrEqual(SPEEDY)
					}
					fnDone()
				} catch (failure: unknown) {
					fnDone(
						failure instanceof Error ||
							typeof failure === 'undefined'
							? failure
							: JSON.stringify(failure),
					)
				}
			})
			// run async
			.run({ async: true })
	})
})
