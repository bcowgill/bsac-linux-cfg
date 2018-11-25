import Benchmark from 'benchmark'
import platform from 'platform'
import spray from './env'

export default function runBenchmark(Tests, async, print) {
	print = print || spray
	print('Benchmarks performed on ' + platform.description)

	const suite = new Benchmark.Suite()

	// add tests
	Object.keys(Tests).forEach(function AddTest(name) {
		suite.add(name, Tests[name])
	})
	// add listeners
	suite
		.on('cycle', function(event) {
			print(String(event.target))
		})
		.on('complete', function() {
			print('Fastest is ' + this.filter('fastest').map('name'))
			print('.')
		})
		// run async
		.run({ async: !!async })
}
