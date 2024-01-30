#!/bin/bash

# specify 'prove' on command line to use prove command to run tests.
PROVE=${1:-}

source ./shell-test.sh

testSuiteBegin lint-package-json "linter for package.json to lock dependencies"
./test-nodes.sh $PROVE
popd > /dev/null

testSuite see "view directory/file/documents using system default or configured programs" $PROVE
testSuite assign-to-team "create an ad hoc team by roles and assign tasks to them" $PROVE
testSuite filter-man "filter perldoc man page output for test plan comparisons" $PROVE
testSuite template-perl-lite "lightweight perl template for simple file processing" $PROVE
testSuite template-perl "perl template for scanning files" $PROVE
testSuite template-perl-inplace "perl template for scanning and editing files in place" $PROVE
testSuite df-k "format df -k command output more legibly" $PROVE
testSuite spaces "show spaces nulls and end of lines" $PROVE
testSuite ls-tabs "report on tab indentation in file" $PROVE
testSuite fix-commas "fix leading/trailing commas in files" $PROVE
testSuite strip-comments "show or strip out comments from files" $PROVE

testSuite pretty-elements "format HTML elements nicely" $PROVE
testSuite ls-tt-tags "list template toolkit tags in templates" $PROVE
testSuite render-tt "render a perl Template::Toolkit page with specific variables set" $PROVE
testSuite scan-code "scan code for static issues" $PROVE
testSuite scan-js "scan javascript for clean code" $PROVE
testSuite calc "perl calc substitute" $PROVE
testSuite git-mv-src "move a source file and repair import statements" $PROVE
testSuite git-mk-js-facade "convert an index.js to a named file with an index.js facaed loader" $PROVE

testSuiteBegin filter-css-colors "unit tests filter and replace CSS colors in files"
$PROVE ./unit-tests.sh

popd > /dev/null

testSuite filter-css-colors "filter and replace CSS colors in files" $PROVE

testSuite perltidy-me "evaluate perltidy formatting options" $PROVE

echo "auto-rename unit tests"
$PROVE ./auto-rename.t

echo "fix-import unit tests"
$PROVE ./fix-import.t
echo "fix-import-order unit tests"
$PROVE ./fix-import-order.t
testSuite fix-import-order "fix javascript import order in files" $PROVE

testSuite json-tools "json tools to manipulat key values" $PROVE

PLAN 2
OK "all test suites completed"
