// time-these.ts A framework for benchmarking code implementations as jest tests.
import { expect, test } from '@jest/globals'
import Benchmark, { Suite, Event } from 'benchmark'

export type Implementation = [string, () => void]

export interface BenchmarkSuite {
	verbose?: boolean
	debug?: boolean
	fastest: string
	slowest: string
	fasterBy?: number
	exceedsHz?: number
	implementations: Implementation[]
}

export default function timeThese(Tests: BenchmarkSuite) {
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

	test(`${FASTEST} should be ${explanation} ${SLOWEST}`, function asyncTestImplementations(fnDone) {
		const suite: Suite = new Benchmark.Suite()
		const results: string[] = []
		const timings: number[] = []

		Tests.implementations.forEach(function addTests([name, fnTest]) {
			suite.add(name, fnTest)
		})
		// add listeners
		suite
			.on('cycle', function (event: Event) {
				if (Tests.debug) {
					// eslint-disable-next-line no-console
					console.warn('cycle', event.target.name, event.target.hz)
				}
				results.push(String(event.target))
				timings.push(event.target.hz ?? 0)
			})
			.on('complete', function (this: Suite) {
				if (Tests.debug) {
					/* eslint-disable no-console, @typescript-eslint/no-unsafe-argument, @typescript-eslint/no-unsafe-return */
					console.warn(
						'FILTERED',
						...this.filter('fastest').map((x) => x),
					)
					/* eslint-enable no-console, @typescript-eslint/no-unsafe-argument, @typescript-eslint/no-unsafe-return */
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
}
