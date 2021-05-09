#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# jshint all the json files found
# See also grep-jshint.sh jshint-add-complexity.sh jshint-analyse-complexity.sh jshint-json.sh jshint-js.sh jshint-set-complexity-js.sh jshint-tests.sh

JSOPTS="--verbose --show-non-errors"

CONFIG=`ls .jshintrc-[gj][rs][uo][n]* 2> /dev/null`
if [ ! -z $CONFIG ]; then
	CONFIG="--config $CONFIG"
	echo CONFIG=$CONFIG
fi

if [ ${1:---quiet} == --verbose ]; then
	find-json.sh | xargs -I '{}' sh -c "( jshint $JSOPTS $CONFIG '{}' && echo '{}': ok )"
else
	jshint $JSOPTS $CONFIG `find-json.sh`
fi

