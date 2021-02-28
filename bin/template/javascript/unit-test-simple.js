#!/usr/bin/env node
// simple unit test framework compatbile with node v0.10.0+
// prove ./unit-test-simple.js
// a cheap watch command...
// perl -e '$src = "./unit-test-simple.js"; $log = "./unit-test-simple.log"; while (1) { system("$src | tee $log") if (-M "$src" < -M "$log"); sleep(5) }'

const RUN_TESTS = true;
const TAP_OUT = process && process.env && process.env.HARNESS_ACTIVE === '1';


//=== utilities ============================================================

var error = console.error
var warn = TAP_OUT ? console.log : console.warn
var log = console.log

//=== unit test library ====================================================

if (!console.group) {
	console.group = console.log
}
if (!console.groupEnd) {
	console.groupEnd = function () {}
}

const BULLET = '○ ' // <- from jest skipped tests '◌ ' <- alternative

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

var group
var groupEnd

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
	if (!TESTS.total) {
		warn('no unit tests performed')
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
		var result = fnTest()
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
	var jsonActual, jsonExpected
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
	var jsonActual, jsonExpected
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
		var result = actualFn()
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
		var actual = actualFn()
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
	plan(3);
	describe('unit tests', function testSuite() {
		describe('something()', function testSomeSuite() {
			it('should handle defaults', function testSomeDefaults() {
				assert(true, false, 'when true1');
			});
			it.skip('should do something', function testSomething() {
				assert(true, false, 'when true2');
			});
			it('should pass', function testPass() {
				assert(true, true, 'when passing');
			});
		}); // something()
	}); // unit tests
} // test()

if (TAP_OUT || RUN_TESTS) {
	test()
}
