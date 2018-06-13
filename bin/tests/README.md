shell-test - a library for testing command line programs

Brent S.A. Cowgill

apologies this is not really in .md format right now.

License: Unlicense http://unlicense.org/

Github original: https://github.com/bcowgill/bsac-linux-cfg/raw/master/bin/tests/shell-test.sh

- Test Anywhere Protocol (TAP) compatible output - use with the prove command for running test suites quietly and summarizing output

- Assertions for checking program exit codes.
- Assertions for file/dir existence, equality, header equality.
- Assertions for comparing program output with a base file stored on disk.
- Test suite function to cd into a test dir and create in/out/base dirs and cleanup out/ afterwards.
- Structure your tests so skipping can be easy.

tests.template.sh - an example of the simplest possible test of a command line program

Directory structure for testing:

test-all.sh      - script to run all tests in subdirs
shell-test.sh    - this library for testing from the shell
program-to-test/ - directory for a program being tested
  ./tests.sh     - the test plan (based on tests.template.sh)
  in/            - directory for input files to the program being tested
  base/          - directory for base snapshots of program output
  out/           - output from program under test generated at test time and verified against the bas/ files

test-all.sh prove   - to run all test plans with the prove program (quieter output and summarizes the pass/fail for each project)

cd program-to-test
./tests.sh        - run the nests noisily showing all pass/fail
prove ./tests.sh  - run the tests with prove to summarize the pass/fail status

When a test fails you will see:

NOT OK 17 files differ - const-file-canon-names

vdiff out/const-file-canon-names.out base/const-file-canon-names.base

if you have an alias for vdiff to your favourite visual difference utility
you simply copy that line and execute it.  You can update the base file from your diff tool directly or simply type (if using bash)

^vdiff^cp

After the pasted command to copy the output file to replace the base file.

alias vdiff='diffmerge --nosplash'

Anatomy of a test suite / case

#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../template/perl/perl-script.pl
CMD=`basename $PROGRAM`
SAMPLE=in/sample.txt
DEBUG=--debug
DEBUG=
# set SKIP=1 to skip all tests except ones you turn on
SKIP=0


# Include testing library and make output dir exist
source ../shell-test.sh
# specify how many tests you expect to run.
PLAN 12

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
# change to 1 if you want to stop after first diff failure
ERROR_STOP=0

echo TEST $CMD command help
TEST=command-help
# change to 1 == $SKIP to run only when SKIP is on
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --help $SAMPLE"

	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	# or if the command should fail with an exit code:
	# $PROGRAM $ARGS > $OUT 2>&1 || assertCommandFails $? $ERR "$PROGRAM $ARGS"

	# if variant things like dates are in the output do a search/replace
	# here on $OUT to fix them up.
	# perl -i -pne 's{\d+-\d+-\d+}{YYYY-MM-DD}xmsg' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

... more tests

cleanUpAfterTests
