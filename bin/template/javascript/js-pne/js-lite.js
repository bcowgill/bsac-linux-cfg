#!/usr/bin/env node
// TODO short description - lightweight nodejs script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests
//  W I N D E V tool useful on windows development machin

const fs = require("fs");

// console.log("process", process);
const cmd = process.mainModule.filename.replace(/^.+\/([^\/]+)$/, "$1");
const ZEROS = Number.MAX_SAFE_INTEGER.toString().replace(/\d/g, "0");

function usage(msg) {
  // const cmd_path = process.mainModule.path;

  if (msg) {
    say(`${msg}\n\n`);
  }
  say(
    /* USAGE */
    `
usage: ${cmd} [--help|--man|-?] filename...

TODO short usage - lightweight node script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests

This program will ...

filename    files to process instead of standard input.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

More details...

See also ...

Example:

${cmd} filename...

`.trim(),
  ); // USAGE
  USAGE;
  process.exit(msg ? 1 : 0);
} // usage()

const VERSION = 0.1;
const DEBUG = true;
const SKIP = 0;

const PAD = 3;

let TESTING = false;
const TEST_CASES = 10;

const ARGC = process.argv.length - 2;
const [_, __, ...ARGV] = process.argv;

// prove command sets HARNESS_ACTIVE in ENV
if (!process.env.NO_UNIT_TESTS) {
  if (process.env.HARNESS_ACTIVE || (ARGC && ARGV[0] === "--test")) {
    tests();
  }
}

if (ARGC && /--help|--man|-\?/.test(ARGV[0])) {
  usage();
}

function check_args() {
  // const source = cmd;
  // if (!pattern) usage('You must provide a file matching pattern.');
  // if (!prefix)  usage('You must provide a destination file name prefix.');
  // if (!is("-f", source)) failure(`source [${source}] must be an existing directory.`);
  // if (!is("-d", destination)) failure(`destination [${destination}] must be an existing directory.`);
} // check_args()

function main() {
  check_args();
  // see auto-rename.pl if you need robust locking...
  // configure_locks(source, destination);
  // obtain_locks();
  try {
    warning("process.env = " + JSON.stringify(process.env, null, 2));
    warning("oops");
    debug("debug");

    // failure("very very bad man");

    // MUSTDO implement this by reading our own file and looking for '__DATA__' line
    //	while (my $line = <DATA>)
    //	{
    //		say("$line");
    //	}
  } catch (EVAL_ERROR) {
    debug(`catch from main: ${EVAL_ERROR}`, 1);
    // if (!signal_received) { remove_locks(EVAL_ERROR) }
    say(EVAL_ERROR);
  }
  //elsif (!signal_received)
  //{
  //	remove_locks();
  //}
} // main()

// pad number with leading zeros
function pad(number, width) {
  const padded = ZEROS.substring(0, width - number.toString().length) + number;
  return padded;
} // pad()

// make tabs 3 spaces
function tab(message) {
  const THREE_SPACES = "   ";
  return message.replace(/\t/g, THREE_SPACES);
} // tab()

// like perl -e -d operators...
// if (is('-d', '/var'))
// https://perlmaven.com/file-test-operators
const isMap = {
  // r w x o R W X O -- cannot do reliably
  //-e by default
  // z custom
  "-s": "size",
  "-f": "isFile",
  "-d": "isDirectory",
  "-l": "isSymbolicLink",
  "-p": "isFIFO",
  "-S": "isSocket",
  "-b": "isBlockDevice",
  "-c": "isCharacterDevice",
  // t u g k T B M A C -- cannot do easily
};
function is(check, path) {
  let result = false;
  try {
    const stats = fs.lstatSync(path);

    if (check === "-e") {
      result = true;
    } else if (check === "-z") {
      result = stats.size === 0;
    } else if (check in isMap) {
      result = stats[isMap[check]]();
    } else {
      failure(`is ${check} unknown file stat operator.`);
    }
  } catch (exception) {
    debug(`is ${check} ${path}: ${exception.toString()} `, 1);
  }
  return result;
} // is()

function failure(warning) {
  throw new Error(`${tab(warning)}\n`);
} // failure()

function debug(msg, levelIn) {
  const level = levelIn || 1;
  let message;

  //	console.log(`debug ${msg.substring(0,10)} debug: ${DEBUG} level: ${level}`);
  if (DEBUG >= level) {
    message = tab(msg) + "\n";
    if (TESTING) {
      diag(`DEBUG: ${message}`);
    } else {
      console.log(message);
    }
  }
  return message;
} // debug()

function warning(warn) {
  const message = `WARN: ${tab(warn)}\n`;
  if (TESTING) {
    diag(message);
  } else {
    console.warn(message);
  }
  return message;
} // warning()

// unit testing diagnostic message for Test Anything Protocol (TAP) output
function diag(message) {
  console.log(`# ${message}`);
  return message;
}

function say(message) {
  if (TESTING) {
    diag(message);
  } else {
    console.log(message);
  }
  return message;
}

main();

//===========================================================================
// unit test functions
//===========================================================================

function test_say(t, expect, message) {
  const result = say(message);
  t.equal(result, expect, `say: [${message}] == [${expect}]`);
}

function test_tab(t, expect, message) {
  const result = tab(message);
  t.equal(result, expect, `tab: [${message}] == [${expect}]`);
}

function test_warning(t, expect, message) {
  const result = warning(message);
  t.equal(result, expect, `warning: [${message}] == [${expect}]`);
}

function test_debug(t, expect, message, level) {
  const result = debug(message, level);
  t.equal(
    result,
    expect,
    `debug: [${message}, ${level}] == [${expect || "undefined"}]`,
  );
}

function test_failure(t, expect, message) {
  let result;
  try {
    failure(message);
  } catch (EVAL_ERROR) {
    result = EVAL_ERROR.toString();
  }
  t.equal(result, expect, `failure: [${message}] == [${expect}]`);
} // test_failure()

function test_pad(t, expect, message) {
  const result = pad(message, PAD);
  t.equal(result, expect, `pad: [${message}] == [${expect}]`);
}

//===========================================================================
// unit test suite helper functions
//#===========================================================================

// setup / teardown and other helpers specific to this test suite
// see auto-rename.pl for setup of lock dirs etc.

//===========================================================================
// unit test library functions
//#===========================================================================

// see auto-rename.pl for a wide variety of test assertions for files, directories, etc.

//===========================================================================
//# unit test suite
//#===========================================================================

function tests() {
  TESTING = true;

  // https://node-tap.org/basics/
  const t = require("tap");

  //  t.test(cmd, (t) => {
  t.plan(TEST_CASES);
  if (!SKIP) test_say(t, "Hello, there", "Hello, there");
  if (!SKIP) test_tab(t, "         Hello", "\t\t\tHello");
  if (!SKIP) test_warning(t, "WARN: WARNING, OH MY!\n", "WARNING, OH MY!");
  if (!SKIP) test_debug(t, void 0, "DEBUG, OH MY!", 10000);
  if (!SKIP) test_debug(t, "DEBUG, OH MY!\n", "DEBUG, OH MY!", -10000);

  if (!SKIP) test_failure(t, "Error: FAILURE, OH MY!\n", "FAILURE, OH MY!");
  if (!SKIP) test_pad(t, "000", "");
  if (!SKIP) test_pad(t, "001", "1");
  if (!SKIP) test_pad(t, "123", "123");
  if (!SKIP) test_pad(t, "1234", "1234");

  //t.pass("this passes");
  //t.fail("this fails");
  //t.ok(myThing, "this passes if truthy");
  //t.equal(myThing, 5, "this passes if the values are equal");
  //t.match(
  //  myThing,
  //  {
  //    property: String,
  //  },
  //  "this passes if myThing.property is a string",
  //);
  //});
  process.exit(0);
} // tests()

("__END__");
`__DATA__
I am the data.
`;
