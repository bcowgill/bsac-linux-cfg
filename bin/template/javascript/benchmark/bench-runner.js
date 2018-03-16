var Benchmark;
try {
	Benchmark = require('benchmark');
} catch (exception) {
	Benchmark = window.Benchmark;
}

function print (message) {
	console.log(message);
}

var Tests = {
	'RegExp#test': function RegExpTest () {
		/o/.test('Hello World!');
	},
	'String#indexOf': function StringIndexOfTest() {
		'Hello World!'.indexOf('o') > -1;
	},
};

print('Benchmarks performed on ' + Benchmark.platform.description);

var suite = new Benchmark.Suite;

// add tests
Object.keys(Tests).forEach(function AddTest (name) {
	suite.add(name, Tests[name]);
});
// add listeners
suite.on('cycle', function(event) {
	print(String(event.target));
})
.on('complete', function() {
	print('Fastest is ' + this.filter('fastest').map('name'));
})
// run async
.run({ 'async': true });

// logs:
// => RegExp#test x 4,161,532 +-0.99% (59 cycles)
// => String#indexOf x 6,139,623 +-1.00% (131 cycles)
// => Fastest is String#indexOf

/*
Benchmark.platform { description: 'Node.js 6.11.4 on Linux 64-bit',
  layout: null,
  manufacturer: null,
  name: 'Node.js',
  prerelease: null,
  product: null,
  ua: null,
  version: '6.11.4',
  os:
   { architecture: 64,
     family: 'Linux',
     version: null,
     toString: [Function: toString] },
  parse: [Function: parse],
  toString: [Function: toStringPlatform] }
*/
