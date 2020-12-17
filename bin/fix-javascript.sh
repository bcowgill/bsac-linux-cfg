#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# fix up code after a save
# CUSTOM settings you may have to change on a new computer

# example use in autofix.sh
# FIX_INDENT=2 FIX_TAB=0 auto-build.sh fix-javascript.sh 'package.json5 app internals server src test config scripts'

FIX_INDENT=${FIX_INDENT:-4}
FIX_TAB=${FIX_TAB:-1}

FILES=.js
#FILES=".js, .scss"

touch auto-build.log
check-blatted-files.sh > check-blatted-files.log
if [ $? == 1 ]; then
	cat check-blatted-files.log | tee pause-build.timestamp
	echo Aborting the jsfix operation until zero file issue resolved. | tee --append pause-build.timestamp
	rm check-blatted-files.log
	exit 1
else
	cat check-blatted-files.log
	rm check-blatted-files.log
	FILES=`egrep \.js auto-build.log`
#	FILES=`egrep '\.(js|scss)' auto-build.log`
	if [ ! -z "$FILES" ]; then
		echo converting tabs to spaces in changed $FILES files
		echo $FILES
		INDENT=$FIX_INDENT INDENT_TAB=$FIX_TAB INPLACE=1 fix-spaces.sh `egrep \.js auto-build.log`
#		INDENT=$FIX_INDENT INDENT_TAB=$FIX_TAB INPLACE=1 fix-spaces.sh `egrep '\.(js|scss)' auto-build.log`

		npm run jsfix
#		npm run json5 && npm run allfix 2> /dev/null
#		npm run test:single 2>&1 | grep -v 'npm ERR!'
#		npm run test 2>&1 | grep -v 'npm ERR!'
#		npm run json5 && npm run lint 2> /dev/null
#		npm run json5 && npm run jscheck:config 2> /dev/null
	fi
fi
