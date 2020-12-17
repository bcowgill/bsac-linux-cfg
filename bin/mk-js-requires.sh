#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# take a list of javascript files and output some javascript to require each one.
# ls *.spec.js | RELATIVE=./ mk-js-requires.sh > combined.test.js
# WINDEV tool useful on windows development machine
# See also mk-js-requires.sh, mk-facade-js.sh, scan-specs.sh, skip-tests.sh
perl -pne '$prefix = $ENV{RELATIVE}; $q = chr(39); chomp; $_ = qq{require($q$prefix$_$q);\n}'
