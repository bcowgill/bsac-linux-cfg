#!/bin/bash
# See also git-check-tests.sh, git-fix-tests.sh, mk-facade-js.sh, scan-specs.sh, skip-tests.sh
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# CUSTOM settings you may need to change on a new machine
git grep -E '^\s*(describe|it)\.(skip|only)' -- '*.spec.js' | egrep --color 'skip|only'
git grep -E '^\s*(xdescribe|xit|fit)' -- '*.spec.js' | egrep --color '(xdescribe|xit|fit)'

git grep -E '^\s*(describe|it)\.(skip|only)' -- '*.test.js' | egrep --color 'skip|only'
git grep -E '^\s*(xdescribe|xit|fit)' -- '*.test.js' | egrep --color '(xdescribe|xit|fit)'
