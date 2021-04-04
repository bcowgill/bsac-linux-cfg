#!/usr/bin/env node
// https://www.britannica.com/science/numeral/Numeral-systems#ref797052

// a cheap / poor watch command...
// perl -e 'while (1) { system("./roman.js | tee roman.log") if (-M "./roman.js" < -M "./roman.log"); sleep(5) }'

const RUN_TESTS = false;
const TAP_OUT = process && process.env && process.env.HARNESS_ACTIVE === '1';
const EXTENDED = false;

let regex = /^[ivxlcdm]+$/i;
let roman = 'ivxlcdm';

const MAX_LENGTH = false; // false, or set to maximum allowed string length
const LONGEST = 100;   // false, or set to limit max repeated numerals
const LARGEST = false; // false, or set to limit maximum valued number
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

function checkThrow(sigil, where) {
  if (!sigil) {
    throw new RangeError(`number cannot be represented with roman numerals ${numerals} [${where}].`);
  }
  return sigil;
}

function romanNumerals(number, sigils = roman) {
  if (number === 0) {
    return '';
  } else if (number >= 10) {
    const ones = number % 10;
    const tens = Math.floor(number / 10);
    if (LONGEST && sigils.length === 1) {
      if (number > LONGEST) {
        throw new RangeError(`number too large, requires more than ${LONGEST} repeated numerals.`)
      }
      return x(sigils, number);
    } else {
      return romanNumerals(tens, sigils.substr(X)) + romanNumerals(ones, sigils);
    }
  } else if (number <= 3) {
    return x(checkThrow(sigils[I], `<=3 ${number}, ${sigils}`), number);
  } else if (number === 4) {
    if (sigils[V]) {
      return checkThrow(sigils[I], `==4V ${number}, ${sigils}`) + sigils[V];
    } else {
      return x(checkThrow(sigils[I], `==4 ${number}, ${sigils}`), 4);
    }
  } else if (number <= 8) {
    if (sigils[V]) {
      return sigils[V] + x(checkThrow(sigils[I], `<=8V ${number}, ${sigils}`), number - 5);
    } else {
      return x(checkThrow(sigils[I], `<=8 ${number}, ${sigils}`), number);
    }
  } else if (number === 9) {
    if (sigils[X]) {
      return checkThrow(sigils[I], `==9X ${number}, ${sigils}`) + sigils[X];
    } else if (sigils[V]) {
      return sigils[V] + x(checkThrow(sigils[I], `==9V ${number}, ${sigils}`), 4);
    } else {
      return x(checkThrow(sigils[I], `==9 ${number}, ${sigils}`), 9);
    }
  }
}

function getRomanFromNumber(number) {
  if (number < 0 || Math.round(number) !== number || !isFinite(number)) {
    throw new RangeError('number must be a positive integer.');
  }
  if (LARGEST && number > LARGEST) {
    throw new RangeError(`number too big, exceeds imposed limit of ${LARGEST}.`);
  }
  if (number === 0) {
    return '';
  }
  const romanNumber =  romanNumerals(number);
  if (MAX_LENGTH && romanNumber.length > MAX_LENGTH) {
    throw newRangeError(`number too long, exceeds imposed limit of ${MAX_LENGTH} characters.`);
  }
  return romanNumber;
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
    this.regex = regex;
    this.roman = roman;
    this.symbols = symbols;

    if (LARGEST) {
      this.LARGEST = LARGEST;
    }
    if (LONGEST) {
      this.LONGEST = LONGEST;
    }
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

let error = console.error
let warn = TAP_OUT ? console.log : console.warn
let log = console.log

//=== unit test library ====================================================

if (!console.group) {
  console.group = console.log;
}
if (!console.groupEnd) {
  console.groupEnd = function () {}
}

const BULLET = '○ '; // <- from jest skipped tests '◌ ' <- alternative

const TESTS = {
  depth: 0,
  fail: 0,
  DASH: TAP_OUT ? '- ' : '',
  NOT_OK: TAP_OUT ? 'not ok ' : '✘ ',
  OK: TAP_OUT ? 'ok ' : '✔ ',
  SKIP: TAP_OUT ? 'not ok ' : BULLET,
  SKIPH: TAP_OUT ? '' : BULLET, // a skipped heading
  SKIPD: TAP_OUT ? '- skipped ' : '', // a dash in the skip message
  pass: 0,
  skip: 0,
  QUIET: TAP_OUT ? false : true,
  total: 0,
}

function plan(number) {
  if (TAP_OUT) {
    warn('1..' + number)
  }
} // plan()

function heading(message) {
  log(' - ' + message)
}

let group;
let groupEnd;

if (TAP_OUT) {
  group = heading
  groupEnd = function () {}
} else {
  group = console.group
  groupEnd = console.groupEnd
}

function tap(glyph, message, dash) {
  dash = dash || TESTS.DASH
  return [glyph, TESTS.total, ' ', dash, message].join('').trim()
}

function ok(message) {
  TESTS.pass += 1
  TESTS.total += 1
  if (TESTS.OK && !TESTS.QUIET) {
    warn(tap(TESTS.OK, message))
  }
} // ok()

function fail(message) {
  TESTS.fail += 1
  TESTS.total += 1
  warn(tap(TESTS.NOT_OK, message))
} // fail()

function skip(message) {
  TESTS.skip += 1
  TESTS.total += 1
  if (TESTS.SKIP && !TESTS.QUIET) {
    warn(tap(TESTS.SKIP, message, TESTS.SKIPD))
  }
} // skip()

function failDump(message, actual, expected, description) {
  description = description || ''
  TESTS.fail += 1
  TESTS.total += 1
  const prefix = tap(TESTS.NOT_OK, message)
  warn(
    [prefix, '\n', TESTS.DASH, 'got'].join(''),
    actual,
    ['\n', TESTS.DASH, 'expected', description, ':'].join(''),
    expected
  )
} // failDump()

function testSummary() {
  let code = 0
  if (!TESTS.total) {
    warn('no unit tests performed')
    code = 1
  } else if (TESTS.pass === TESTS.total) {
    log('all ' + TESTS.pass + ' tests passed.')
  } else {
    warn(
      [
        TESTS.fail,
        ' tests failed, ',
        TESTS.skip,
        ' tests skipped, ',
        TESTS.pass,
        ' tests passed, ',
        TESTS.total,
        ' total.',
      ].join('')
    )
    code = Math.min(TESTS.fail, 255)
    setImmediate(function terminate() {
      process.exit(code)
    })
  }
} // testSummary()

function describe(title, fnSuite) {
  group(title)
  TESTS.depth += 1
  try {
    fnSuite()
  } catch (exception) {
    fail('describe "' + title + '" caught ' + exception)
    error(exception)
  } finally {
    TESTS.depth -= 1
    if (!TESTS.depth) {
      testSummary()
    }
    groupEnd(title)
  }
} // describe()

function xdescribe(title, fnSkip) {
  const header = TESTS.SKIPH + 'skipped - ' + title
  group(header)
  // set a skip marker to skip all tests...
  if (!TESTS.depth) {
    testSummary()
  }
  groupEnd(header)
}
describe.skip = xdescribe

function it(title, fnTest) {
  group(title)
  try {
    const result = fnTest()
    if (result) {
      fail('it expected falsy, got ' + result)
    }
  } catch (exception) {
    fail('it "' + title + '" caught ' + exception)
    error(exception)
  } finally {
    groupEnd(title)
  }
} // it()

function xit(title, fnSkip) {
  const header = TESTS.SKIPH + 'skipped - ' + title
  group(header)
  skip(title)
  groupEnd(header)
}
it.skip = xit

function assert(actual, expected, title) {
  title = title || ''
  // console.warn('assert', actual, expected, title)
  if (actual === expected) {
    ok(title)
  } else if (expected instanceof RegExp && expected.test(actual)) {
    ok(title)
  } else if (
    typeof actual === 'number' &&
    typeof expected === 'number' &&
    isNaN(actual) &&
    isNaN(expected)
  ) {
    ok(title)
  } else {
    failDump(title, actual, expected)
  }
} // assert()

function assertArray(actual, expected, title) {
  title = title || ''
  let jsonActual, jsonExpected
  // console.warn('assertArray', actual, expected, title)
  if (actual === expected) {
    ok(title)
  } else if (
    (jsonActual = JSON.stringify(actual)) ===
    (jsonExpected = JSON.stringify(expected))
  ) {
    ok(title)
  } else {
    failDump(title, jsonActual, jsonExpected)
  }
} // assertArray()

function assertObject(actual, expected, title) {
  title = title || ''
  let jsonActual, jsonExpected
  // console.warn('assertObject', actual, expected, title)
  if (actual === expected) {
    ok(title)
  } else if (
    (jsonActual = JSON.stringify(actual)) ===
    (jsonExpected = JSON.stringify(expected))
  ) {
    ok(title)
  } else {
    failDump(title, jsonActual, jsonExpected)
  }
} // assertObject()

function assertThrows(actualFn, expected, title) {
  title = title || ''
  // console.warn('assertThrows', actualFn, expected, title)
  try {
    let result = actualFn()
    failDump(title, result, 'to throw but did not. [' + expected)
  } catch (exception) {
    if (typeof expected === 'function') {
      assertInstanceOf(exception, expected, title)
    } else {
      assert(exception, expected, title)
    }
  }
}

function assertNotThrows(actualFn, expected, title) {
  title = title || ''
  // console.warn('assertNotThrows', actualFn, expected, title)
  try {
    let actual = actualFn()
    assert(actual, expected, title)
  } catch (exception) {
    failDump(title, exception, 'not to throw but did.')
  }
}

function assertInstanceOf(actual, expected, title) {
  title = title || ''
  if (actual instanceof expected) {
    ok(title)
  } else {
    failDump(title, actual, expected, ' instance of')
  }
} // assertInstanceOf()

//=== unit tests ===========================================================

function test() {
  plan(32);
  describe('unit tests', function testSuite() {
  describe('new RomanNumber()', function testNewRomanNumberSuite() {
      it('should have all properties assigned', function testNewRomanNumber() {
        const number = new RomanNumber(1999);
        assert(number.string, 'mcmxcix', 'should have string property');
        assert(number.value, 1999, 'should have value property');
        assert(number.LONGEST, 100, 'should have LONGEST property');
        assert(number.regex.toString(), '/^[ivxlcdm]+$/i', 'should have regex property');
        assert(number.roman, 'ivxlcdm', 'should have roman property');
        assert(number.symbols.i.amount, 1, 'should have symbols property');
      });
    });

  describe('getRomanFromNumber()', function testGetRomanFromNumberSuite() {
    it('should handle invalid', function testGetRomanFromNumberInvalid() {
        assertThrows(() => new RomanNumber(-12), /RangeError: number must be a positive integer\./, 'when negative');
        assertThrows(() => new RomanNumber(1.5), /RangeError: number must be a positive integer\./, 'when non-integer');
        assertThrows(() => new RomanNumber(400000), /RangeError: number too large, requires more than 100 repeated numerals./, 'when 400000 too big');
        assertThrows(() => new RomanNumber(x('m', 401)), /RangeError: number too large, requires more than 100 repeated numerals./, 'when m x 401 too big');
        //assertThrows(() => new RomanNumber(4000), /RangeError: number cannot be represented with roman numerals i,v,x,l,c,d,m\./, 'when 4000 too big');
        //assertThrows(() => new RomanNumber('mmmm'), /RangeError: number cannot be represented with roman numerals i,v,x,l,c,d,m\./, 'when mmmm too big');
        //assertThrows(() => new RomanNumber(40000), /RangeXError: number cannot be represented with roman numerals i,v,x,l,c,d,m\./, 'when 40000 too big');
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
        const all = new RomanNumber(roman);
        assert(all.toString(), 'cccxxxiv', 'when using roman numeral set toString');
        assert(all.valueOf(), 334, 'when using roman numeral set valueOf');
        const allReversed = new RomanNumber(roman.split('').reverse().join(''))
        assert(allReversed.toString(), 'mdclxvi', 'when using reversed roman numeral set toString');
        assert(allReversed.valueOf(), 1666, 'when using reversed roman numeral set valueOf');// ivxlcdm
      });

    it('should handle canonizing non-standard numbers', function testGetRomanFromStringCanon() {
        assert((new RomanNumber('vl')).toString(), 'xlv', 'when vl toString');
        assert((new RomanNumber('vl')).valueOf(), 45, 'when vl valueOf');
      });
    }); // getRomanFromString()
  }); // unit tests
} // test()

if (TAP_OUT || RUN_TESTS) {
  test();
}
