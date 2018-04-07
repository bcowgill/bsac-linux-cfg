
function loadCode (modName, varName) {
	var imported;
	try {
		imported = require(modName);
	} catch (exception) {
		//console.error('loadCode', exception);
		imported = window[varName];
	}
	//console.log('loadCode ' + varName + ' from ' + modName, imported);
	return imported;
}
var runBenchmark = loadCode('./bench-tools', 'runBenchmark');

var Tests = {
	'RegExp#test': function RegExpTest () {
		/o/.test('Hello World!');
	},
	'String#indexOf': function StringIndexOfTest() {
		'Hello World!'.indexOf('o') > -1;
	},
};

runBenchmark(Tests);

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
