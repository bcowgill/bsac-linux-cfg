#!/bin/bash

# specify 'prove' on command line to use prove command to run tests.
PROVE=${1:-}

source ./shell-test.sh

if node --version | grep -E '(v1[23456789]|v[23456789]\d)\.' ; then
	OK "node version is sufficient for git-mk-js-facade.sh test plan"
else
	NOT_OK "node version is insufficient to run the git-mk-js-facade.sh test plans. try nvm use `cat .nvmrc`"
	exit 1
fi

testSuiteBegin lint-package-json "linter for package.json to lock dependencies"
./test-nodes.sh $PROVE
popd > /dev/null

testSuite file-break "add a line break after file change in a grep listing" $PROVE
testSuite anglicise "convert letters from other alphabets to plain english letters" $PROVE

testSuite see "view directory/file/documents using system default or configured programs" $PROVE
testSuite assign-to-team "create an ad hoc team by roles and assign tasks to them" $PROVE
testSuite filter-man "filter perldoc man page output for test plan comparisons" $PROVE
testSuite pee "filter piped output and clean it up before logging to file" $PROVE
testSuite filter-script "filter the output log of the script command" $PROVE
testSuite filter-long "filter output by showing a number of ellipsis characters for lines that are too long" $PROVE
testSuite filter-coverage "filter the jest test coverage output to suppress noise" $PROVE
testSuite filter-sounds "filter a list or grep output for sound files" $PROVE
testSuite filter-code-files "filter a list or grep output suppressing code files" $PROVE

testSuite filter-json-commas "filter json files, fixing problems with commas" $PROVE

#testSuite filter-url "filter files" $PROVE
#testSuite filter-whitespace "filter files" $PROVE
#testSuite filter-newlines "filter files" $PROVE
#testSuite filter-man "filter files" $PROVE

#testSuite filter-punct "filter files" $PROVE
#testSuite filter-indents "filter files" $PROVE
#testSuite filter-generify "filter files" $PROVE

testSuite filter-images "filter a list or grep output for image files" $PROVE
testSuite filter-videos "filter a list or grep output for video files" $PROVE
testSuite filter-drawings "filter a list or grep output for drawing files" $PROVE
testSuite filter-fonts "filter a list or grep output for font files" $PROVE
testSuite filter-docs "filter a list or grep output for document files" $PROVE
testSuite filter-bak "filter a list or grep output for backup files" $PROVE
testSuite filter-osfiles "filter a list or grep output for operating system special files" $PROVE

testSuite filter-source "filter a list or grep output for source code based files" $PROVE
testSuite filter-scripts "filter a list or grep output for script based program files" $PROVE
testSuite filter-configs "filter a list or grep output for configuration files" $PROVE
testSuite filter-min "filter a list or grep output for minimised files" $PROVE
testSuite filter-web "filter a list or grep output for web development files" $PROVE
testSuite filter-css "filter a list or grep output for stylesheet files" $PROVE
testSuite filter-text "filter a list or grep output for text files" $PROVE
testSuite filter-zips "filter a list or grep output for archive and compressed files" $PROVE
testSuite filter-built-files "filter a list or grep output for files built by a make system" $PROVE

#testSuite filter-mime-audio "filter files" $PROVE
#testSuite filter-mime-video "filter files" $PROVE
#testSuite filter-file "filter files" $PROVE

#testSuite filter-id3 "filter files" $PROVE
#testSuite filter-css-colors "filter files" $PROVE

testSuite math-rep "convert mathematical markup into unicode characters" $PROVE

testSuite template-perl-lite "lightweight perl template for simple file processing" $PROVE
testSuite template-perl "perl template for scanning files" $PROVE
testSuite template-perl-inplace "perl template for scanning and editing files in place" $PROVE
testSuite df-k "format df -k command output more legibly" $PROVE
testSuite spaces "show spaces nulls and end of lines" $PROVE
testSuite ls-tabs "report on tab indentation in file" $PROVE
testSuite fix-commas "fix leading/trailing commas in files" $PROVE
testSuite strip-comments "show or strip out comments from files" $PROVE
testSuite grep-file-line "scan an output log for filenames, lines, columns and error context" $PROVE
testSuite grep-vim "grep a file for some text and then generate a bash script to open vim on each match line" $PROVE

testSuite pretty-elements "format HTML elements nicely" $PROVE
testSuite ls-tt-tags "list template toolkit tags in templates" $PROVE
testSuite render-tt "render a perl Template::Toolkit page with specific variables set" $PROVE
testSuite scan-code "scan code for static issues" $PROVE
testSuite scan-js "scan javascript for clean code" $PROVE
testSuite calc "perl calc substitute" $PROVE
testSuite git-mk-js-facade.sh "convert an index.js to a named file with an index.js facaed loader" $PROVE

testSuite perltidy-me "evaluate perltidy formatting options" $PROVE

echo "auto-rename unit tests"
$PROVE ./auto-rename.t

echo "fix-import unit tests"
$PROVE ./fix-import.t
echo "fix-import-order unit tests"
$PROVE ./fix-import-order.t
testSuite fix-import-order "fix javascript import order in files" $PROVE

testSuite json-tools "json tools to manipulat key values" $PROVE

testSuite git-mv-src "move a source file and repair import statements" $PROVE

testSuite css-color-scale "generates a quantised CSS color scale" $PROVE
testSuite ls-cmds-used "lists external commands used in scripts" $PROVE

testSuite utf8spaces "show unicode space characters and javascript definitions for them" $PROVE
testSuite utf8dbg "show various properties of unicode characters" $PROVE

testSuite get-meta "shows id3v2 meta-data tags for files" $PROVE
testSuite ls-meta "shows id3v2 and exif meta-data tags for files" $PROVE
testSuite ls-music "shows a one liner listing of common music meta-data fields" $PROVE
testSuite id3v2-ls "shows the genre of a music file along with its name" $PROVE
testSuite id3v2-track "shows the track number of a music file along with its name" $PROVE

testSuite mv-apostrophe "renames files and directories with apostrophes in them" $PROVE
testSuite rename-files "rename files automatcillay by converting characters to dashes" $PROVE
testSuite fix-song-names "fixes the names of song files addressing apostrophes and other special characters" $PROVE
testSuite renumber-files "rename files with consectutive numbers" $PROVE
testSuite renumber-by-time "rename files with consectutive numbers by their timestamp" $PROVE

testSuite dateAdd "add days to a specific date" $PROVE
testSuite dateDaysBetween "determine the days/hours/minutes/seconds between two dates" $PROVE

testSuite mv-to-tar "move a directory to a tar file" $PROVE
testSuite mv-to-zip "move a directory to a zip file" $PROVE
testSuite cp-fast "perform a fast copy of a huge file or huge directory tree" $PROVE

#================================================================
testSuiteBegin filter-css-colors "unit tests filter and replace CSS colors in files"
$PROVE ./unit-tests.sh

popd > /dev/null

testSuite filter-css-colors "filter and replace CSS colors in files" $PROVE
#================================================================

PLAN 2
OK "all test suites completed"
