#!/bin/bash
# jshint all the javascript files which aren't tests found

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

