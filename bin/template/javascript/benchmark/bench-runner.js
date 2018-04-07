
function loadCode (modName, varName) {
	var imported;
	try {
		imported = require(modName);
	} catch (exception) {
		//console.error('loadCode', exception);
		if (typeof window === 'undefined') {
			throw new Error(varName + ' = require(' + modName + ') unable to load or find in globals');
		}
		imported = window[varName];
	}
	if (typeof imported === 'undefined' || imported === null) {
		throw new Error(varName + ' = require(' + modName + ') unable to load or find in globals');
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
	'String#match': function StringMatchTest() {
		!!'Hello World!'.match(/o/);
	}
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
