#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# jshint all the javascript files which aren't tests found
# See also grep-jshint.sh jshint-add-complexity.sh jshint-analyse-complexity.sh jshint-json.sh jshint-js.sh jshint-set-complexity-js.sh jshint-tests.sh

JSOPTS="--verbose --show-non-errors"

CONFIG=
if [ ! -z $CONFIG ]; then
	CONFIG="--config $CONFIG"
	echo CONFIG=$CONFIG
fi

if [ ${1:---quiet} == --verbose ]; then
	find-js.sh | grep -v /test/ | xargs -I '{}' sh -c "( jshint $JSOPTS $CONFIG $* '{}' && echo '{}': ok )"
else
	jshint $JSOPTS $CONFIG $* `find-js.sh | grep -v /test/`
fi

