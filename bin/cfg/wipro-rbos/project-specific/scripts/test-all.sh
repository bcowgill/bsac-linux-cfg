#!/bin/bash
# run all jest test suites (not just those which differ from source control) and log to a log file.
# test-all.sh --env=jsdom --coverage
# test-all.sh --updateSnapshot
TESTLOG=_tests.log
npm test -- --watchAll=false $* 2>&1 | pee.pl $TESTLOG
