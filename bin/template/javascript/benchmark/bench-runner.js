// Env.js -- subset
// Detecting your environment and getting access to the global object
// http://stackoverflow.com/questions/17575790/environment-detection-node-js-or-browser
// https://developer.mozilla.org/en-US/docs/Web/API/Window/self

'use strict'

const makeGet = function (globalVar) {
	return 'try { __global = __global || ' + globalVar + '} catch (exception) {}'
}

// eslint-disable-next-line no-new-func
const getGlobal = new Function(
	'var __global;'
	+ makeGet('window')
	+ makeGet('global')
	+ makeGet('WorkerGlobalScope')
	+ 'return __global;'
)

function _getOutputDiv (document, id) {
	var div;
	try {
		div = document.getElementById(id);
		if (!div) {
			const newDiv = document.createElement('div');
			newDiv.id = id;
			document.body.insertBefore(newDiv, document.body.firstChild);
			div = document.getElementById(id);
		}
	}
	finally { void 0 }
	return div;
}

function _addElement (document, message) {
	try {
		const newDiv = document.createElement('div')
			, newContent = document.createTextNode(message)
			, div = _getOutputDiv(document, 'spray-output-div');

		newDiv.appendChild(newContent)
		div.appendChild(newDiv);
	}
	finally { void 0 }
}

// Show a message in every possible place.
const spray = function () {
	const global = getGlobal()
		, args = Array.prototype.slice.call(arguments)
	if (global.document && global.document.body) {
		_addElement(global.document, args.join())
	}
	if (global.console && global.console.log) {
		global.console.log.apply(global.console, args)
	}
}
// End of Env.js subset

var Benchmark;
try {
	Benchmark = require('benchmark');
} catch (exception) {
	const global = getGlobal();
	Benchmark = global.Benchmark;
}

var Tests = {
	'RegExp#test': function RegExpTest () {
		/o/.test('Hello World!');
	},
	'String#indexOf': function StringIndexOfTest() {
		'Hello World!'.indexOf('o') > -1;
	},
};

function runBenchmark (Tests, Benchmark, print) {
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
}

runBenchmark(Tests, Benchmark, spray);

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
