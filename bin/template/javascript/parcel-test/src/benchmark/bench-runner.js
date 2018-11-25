import runBenchmark from './bench-tools'
import TestClosureObj from './test-closure-obj'
import TestFind from './test-find'
import spray from './env'

// prettier-ignore
const Tests = [
	TestFind,
	TestClosureObj[0],
	TestClosureObj[1],
]
const async = Tests.length === 1
spray(new Date() + ' we will begin after a short delay.')
setTimeout(function delayStart() {
	Tests.forEach(function BenchMarkTest(tests) {
		runBenchmark(tests, async)
	})
}, 1000)

// logs:
// Benchmarks performed on Node.js 8.6.0 on Linux 64-bit
// RegExp#test x 9,379,823 ops/sec ±1.25% (85 runs sampled)
// String#indexOf x 111,961,690 ops/sec ±1.02% (85 runs sampled)
// String#match x 8,411,856 ops/sec ±1.40% (87 runs sampled)
// Fastest is String#indexOf
// .
