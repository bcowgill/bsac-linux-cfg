#!/usr/bin/env node

// a cheap watch command...
// perl -e '$src = "./unit-test-simple.js"; $log = "./unit-test-simple.log"; while (1) { system("$src | tee $log") if (-M "$src" < -M "$log"); sleep(5) }'

const RUN_TESTS = true;

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
  SKIP  : '○ ', // 'SKIP', // from jest skipped tests
  //SKIP  : '◌ ', // 'SKIP',
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
    const result = actualFn();
    failDump(title, result, `to throw but did not. [${expected}]`);
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
    failDump(title, exception, 'not to throw but did.');
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
	describe('something()', function testSomeSuite() {
	  it('should handle defaults', function testSomeDefaults() {
        assert(true, false, 'when true');
      });
	  it.skip('should do something', function testSomething() {
        assert(true, false, 'when true');
      });
    }); // something()
  }); // unit tests
} // test()

if (RUN_TESTS) {
  test();
}
