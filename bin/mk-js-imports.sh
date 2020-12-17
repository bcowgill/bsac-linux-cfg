#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# take a list of javascript files and output some javascript to import each one.
# ls *.spec.js | RELATIVE=./ mk-js-imports.sh > combined.test.js
# See also mk-js-requires.sh, mk-facade-js.sh, scan-specs.sh, skip-tests.sh
# WINDEV tool useful on windows development machine
perl -pne '$prefix = $ENV{RELATIVE}; $q = chr(39); chomp; $_ = qq{import $q$prefix$_$q;\n}'
