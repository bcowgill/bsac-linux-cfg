#!/bin/bash

# specify 'prove' on command line to use prove command to run tests.
PROVE=${1:-}

source ./shell-test.sh

echo "fix-import unit tests"
$PROVE ./fix-import.t

testSuite filter-man "filter perldoc man page output for test plan comparisons" $PROVE
testSuite template-perl "perl template for scanning files" $PROVE
testSuite template-perl-inplace "perl template for scanning and editing files in place" $PROVE
testSuite df-k "format df -k command output more legibly" $PROVE
testSuite spaces "show spaces nulls and end of lines" $PROVE
testSuite ls-tabs "report on tab indentation in file" $PROVE

testSuite pretty-elements "format HTML elements nicely" $PROVE
testSuite ls-tt-tags "list template toolkit tags in templates" $PROVE
testSuite render-tt "render a perl Template::Toolkit page with specific variables set" $PROVE
testSuite perltidy-me "evaluate perltidy formatting options" $PROVE
testSuite scan-code "scan code for static issues" $PROVE
testSuite scan-js "scan javascript for clean code" $PROVE

testSuiteBegin filter-css-colors "unit tests filter and replace CSS colors in files"
$PROVE ./unit-tests.sh

popd > /dev/null

testSuite filter-css-colors "filter and replace CSS colors in files" $PROVE
testSuite git-mv-src "move a source file and repair import statements" $PROVE

PLAN 2
OK "all test suites completed"
