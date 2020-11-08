#!/usr/bin/env node

// a cheap watch command...
// perl -e 'while (1) { system("./roman.js | tee roman.log") if (-M "./roman.js" < -M "./roman.log"); sleep(5) }'

const RUN_TESTS = true;

const EXTENDED = false;

let regex = /^[ivxlcdm]+$/i;
let roman = 'ivxlcdm';

const X = 2;
const V = 1;
const I = 0;

const symbols = {
  i: { amount: 1, },
  v: { amount: 5, },
  x: { amount: 10, },
  l: { amount: 50, },
  c: { amount: 100, },
  d: { amount: 500, },
  m: { amount: 1000, },
};

if (EXTENDED) {
  regex = /^[ivxlcdmↁↂↇↈ]+$/i;
  roman += 'ↁↂↇↈ';
  symbols['ↁ']  = { amount: 5000, };
  symbols['ↂ'] = { amount: 10000, };
  symbols['ↇ']  = { amount: 50000, };
  symbols['ↈ'] = { amount: 100000, };
}

const numerals = roman.split('').join(',');

/* Add a bar above letter to multiply by 1000 (or capitalise)
const roman = 'ivxlcdmVXLCDM';
  V: { amount: 5000, },
  X: { amount: 10000, },
  L: { amount: 50000, },
  C: { amount: 100000, },
  D: { amount: 500000, },
  M: { amount: 1000000, },
*/
/* ↁↂↇↈ
ↁ	U+2181	[LetterNumber]	ROMAN NUMERAL FIVE THOUSAND
ↂ	U+2182	[LetterNumber]	ROMAN NUMERAL TEN THOUSAND
Ↄ	U+2183	[UppercaseLetter]	ROMAN NUMERAL REVERSED ONE HUNDRED
ↅ	U+2185	[LetterNumber]	ROMAN NUMERAL SIX LATE FORM
ↆ	U+2186	[LetterNumber]	ROMAN NUMERAL FIFTY EARLY FORM
ↇ	U+2187	[LetterNumber]	ROMAN NUMERAL FIFTY THOUSAND
ↈ	U+2188	[LetterNumber]	ROMAN NUMERAL ONE HUNDRED THOUSAND
*/

// like the perl x operator
function x(token, repeat) {
  let string = '';
  for (idx = 0; idx < repeat; idx += 1)
  {
    string += token;
  }
  return string;
}

function romanNumerals(number, sigils = roman) {
  if (number === 0) {
    return '';
  } else if (number >= 10) {
    const ones = number % 10;
    const tens = Math.floor(number / 10);
    return romanNumerals(tens, sigils.substr(X)) + romanNumerals(ones, sigils);
  } else if (number <= 3) {
    return x(checkThrow(sigils[I]), number);
  } else if (number === 4) {
    return checkThrow(sigils[I]) + checkThrow(sigils[V]);
  } else if (number <= 8) {
    return checkThrow(sigils[V]) + x(checkThrow(sigils[I]), number - 5);
  } else if (number === 9) {
    return checkThrow(sigils[I]) + checkThrow(sigils[X]);
  }
}

function checkThrow(sigil) {
  if (!sigil) {
    throw new RangeError(`number cannot be represented with roman numerals ${numerals}`);
  }
  return sigil;
}

function getRomanFromNumber(number) {
  if (number < 0 || Math.round(number) !== number || !isFinite(number)) {
    throw new RangeError('number must be a positive integer');
  }
  if (number === 0) {
    return '';
  }
  return romanNumerals(number);
}

function getRomanFromString(string) {
  if (!regex.test(string)) {
    throw new TypeError(`string must consist of roman numerals ${numerals}`);
  }
  let sum = 0;
  let letters = string.toLowerCase();
  while (letters.length) {
    const symbol = letters[0];
    let amount = symbols[symbol].amount;
    if (letters[1] && symbols[letters[1]].amount > amount) {
      amount = -amount;
    }
    sum += amount;
    letters = letters.substr(1);
  }
  return sum;
}

function RomanNumber(mixed) {
	if (typeof mixed === 'number') {
      this.value = mixed;
	} else {
      this.string = `${mixed}`;
	  this.value = getRomanFromString(this.string);
	}
    this.string = getRomanFromNumber(this.value);
}

RomanNumber.prototype = {
  toString: function () {
    return this.string;
  },
  valueOf: function () {
    return this.value;
  },
};

//=== utilities ============================================================

function error(...args) {
  console.error(...args);
}

function warn(...args) {
  console.warn(...args);
}

function log(...args) {
  console.log(...args);
}

//=== unit test library ====================================================

if (!console.group) {
  console.group = console.log;
}
if (!console.groupEnd) {
  console.groupEnd = () => {};
}

const TESTS = {
  depth : 0,
  fail  : 0,
  NOT_OK: '✘ ', // 'NOT OK ',
  OK    : '✔ ', // 'OK ',
  SKIP  : 'o', // 'SKIP ', // TODO grab character from jest skip circle
  pass  : 0,
  skip  : 0,
  QUIET : true,
  total : 0
};

function ok(message) {
  TESTS.pass  += 1;
  TESTS.total += 1;
  if (TESTS.OK && !TESTS.QUIET) {
	warn(`${TESTS.OK}${TESTS.total} ${message}`.trim());
  }
} // ok()

function fail(message) {
  TESTS.fail  += 1;
  TESTS.total += 1;
  warn(`${TESTS.NOT_OK}${TESTS.total} ${message}`.trim());
} // fail()

function skip(message) {
  TESTS.skip  += 1;
  TESTS.total += 1;
  if (TESTS.SKIP && !TESTS.QUIET) {
	warn(`${TESTS.SKIP}${TESTS.total} ${message}`.trim());
  }
} // skip()

function failDump(message, actual, expected, description = '') {
  TESTS.fail  += 1;
  TESTS.total += 1;
  const prefix = `${TESTS
			        .NOT_OK}${TESTS
			                  .total} ${message}`
			.trim();
  warn(`${prefix}\ngot`, actual, `\nexpected${description}:`, expected);
} // failDump()

function testSummary() {
  if (!TESTS.total) {
	warn('no unit tests performed')
  } else if (TESTS.pass === TESTS.total) {
	log(`all ${TESTS.pass} tests passed.`)
  } else {
	warn(`${TESTS.fail} tests failed, ${TESTS.skip} tests skipped, ${TESTS.pass} tests passed, ${TESTS.total} total.`)
  }
} // testSummary()

function describe(title, fnSuite) {
  console.group(title);
  TESTS.depth += 1;
  try
  {
	fnSuite();
  } catch (exception) {
	fail(`describe "${title}" caught ${exception}`);
	error(exception);
  } finally
  {
	TESTS.depth -= 1;
	if (!TESTS.depth) {
	  testSummary();
	}
	console.groupEnd(title);
  }
} // describe()

function xdescribe(title, fnSkip) {
  const header = `${TESTS.SKIP} skipped - ${title}`;
  console.group(header);
  // set a skip marker to skip all tests...
  if (!TESTS.depth) {
	testSummary();
  }
  console.groupEnd(header);
}
describe.skip = xdescribe;

function it(title, fnTest) {
  console.group(title);
  try
  {
	const result = fnTest();
	if (result) {
	  fail(`it expected falsy, got ${result}`);
	}
  } catch (exception) {
	fail(`it "${title}" caught ${exception}`);
	error(exception);
  } finally
  {
	console.groupEnd(title);
  }
} // it()

function xit(title, fnSkip) {
  const header = `${TESTS.SKIP} skipped - ${title}`;
  console.group(header);
  skip(title)
  console.groupEnd(header);
}
it.skip = xit;

function assert(actual, expected, title = '') {
  // console.warn('assert', actual, expected, title)
  if (actual === expected) {
	ok(title);
  } else if (expected instanceof RegExp && expected.test(actual)) {
    ok(title);
  } else if (typeof actual === 'number' && typeof expected === 'number' && isNaN(actual) && isNaN(expected)) {
	ok(title);
  } else {
	failDump(title, actual, expected);
  }
} // assert()

function assertThrows(actualFn, expected, title = '') {
  // console.warn('assertThrows', actualFn, expected, title)
  try {
    actualFn();
    failDump(title, expected, 'Expected to throw but did not.');
  }
  catch (exception) {
    if (typeof expected === 'function') {
      assertInstanceOf(exception, expected, title);
    } else {
      assert(exception, expected, title);
    }
  }
}

function assertNotThrows(actualFn, expected, title = '') {
  // console.warn('assertNotThrows', actualFn, expected, title)
  try {
    const actual = actualFn();
    assert(actual, expected, title);
  }
  catch (exception) {
    failDump(title, exception, 'Expected not to throw but did.');
  }
}

function assertInstanceOf(actual, expected, title = '') {
  if (actual instanceof expected) {
	ok(title);
  } else {
	failDump(title, actual, expected, ' instance of');
  }
} // assertInstanceOf()

//=== unit tests ===========================================================

function test() {
  describe('unit tests', function testSuite() {
	describe('getRomanFromNumber()', function testGetRomanFromNumberSuite() {
	  it('should handle invalid', function testGetRomanFromNumberInvalid() {
        assertThrows(() => new RomanNumber(-12), /RangeError: number must be a positive integer/, 'when negative');
        assertThrows(() => new RomanNumber(1.5), /RangeError: number must be a positive integer/, 'when non-integer');
        assertThrows(() => new RomanNumber(4000), /RangeError: number cannot be represented with roman numerals i,v,x,l,c,d,m/, 'when too big');
        assertThrows(() => new RomanNumber('mmmm'), /RangeError: number cannot be represented with roman numerals i,v,x,l,c,d,m/, 'when mmmm too big');
});

	  it('should handle numbers', function testGetRomanFromNumber() {
        assertInstanceOf(new RomanNumber(1), RomanNumber, 'when 1');
        assert((new RomanNumber(0)).toString(), '', 'when zero is empty string');
        assert((new RomanNumber(0)).valueOf(), 0, 'when zero valueOf');
        assert((new RomanNumber(1)).toString(), 'i', 'when 1 toString');
        assert((new RomanNumber(1)).valueOf(), 1, 'when 1 valueOf');
        assert((new RomanNumber(2020)).toString(), 'mmxx', 'when 2020 toString');
        assert((new RomanNumber(1967)).toString(), 'mcmlxvii', 'when 2020 toString');
        // assert((new RomanNumber(4000)).toString(), 'mↁ', 'when 4000 toString');
      });
    }); // getRomanFromNumber()

	describe('getRomanFromString()', function testGetRomanFromStringSuite() {
	  it('should handle defaults', function testGetRomanFromStringDefault() {
        assertThrows(() => new RomanNumber(), /TypeError: string must consist of roman numerals i,v,x,l,c,d,m/, 'when undefined');
        assertThrows(() => new RomanNumber(null), /TypeError: string must consist of roman numerals i,v,x,l,c,d,m/, 'when null');
      });

	  it('should handle upper case', function testGetRomanFromStringUpperCase() {
        assert((new RomanNumber('MCMLXXXVIII')).toString(), 'mcmlxxxviii', 'when MCMLXXXVIII toString');
        assert((new RomanNumber('MCMLXXXVIII')).valueOf(), 1988, 'when MCMLXXXVIII valueOf');
      });

	  it('should handle string', function testGetRomanFromString() {
        assertInstanceOf(new RomanNumber('i'), RomanNumber, 'when i');
        assert((new RomanNumber('i')).toString(), 'i', 'when i toString');
        assert((new RomanNumber('i')).valueOf(), 1, 'when i valueOf');
        assert((new RomanNumber('mdclxvi')).toString(), 'mdclxvi', 'when mdclxvi toString');
        assert((new RomanNumber('mdclxvi')).valueOf(), 1666, 'when mdclxvi valueOf');
      });

	  it('should handle canonizing non-standard numbers', function testGetRomanFromStringCanon() {
        assert((new RomanNumber('vl')).toString(), 'xlv', 'when vl toString');
        assert((new RomanNumber('vl')).valueOf(), 45, 'when vl valueOf');
      });
    }); // getRomanFromString()
  }); // unit tests
} // test()

if (RUN_TESTS) {
  test();
}

console.log('that is all')
