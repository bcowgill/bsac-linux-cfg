#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# scan for spec.js files in test/ dir to put into a test-runner.js file
# See also git-check-tests.sh, git-fix-tests.sh, git-grep-skipped.sh, mk-facade-js.sh, skip-tests.sh

(\
	find test -name '*.spec.js' | egrep '/models?/';\
	find test -name '*.spec.js' | egrep '/collections/';\
	find test -name '*.spec.js' | egrep '/views/';\
	find test -name '*.spec.js' | egrep '/controllers/'\
)\
	| perl -pne '$q=chr(39); s{\A}{    $q}xmsg; s{\n}{$q,\n}xmsg; s{${q}test/}{$q}xmsg'
