#!/bin/bash
# fix up code after a save

# example use in autofix.sh
# scripts/auto-build.sh scripts/fix.sh 'package.json5 app internals server src test config scripts'

touch auto-build.log
./scripts/check-blatted-files.sh > check-blatted-files.log
if [ $? == 1 ]; then
	cat check-blatted-files.log | tee pause-build.timestamp
	echo Aborting the jsfix operation until zero file issue resolved. | tee --append pause-build.timestamp
	rm check-blatted-files.log
	exit 1
else
	cat check-blatted-files.log
	rm check-blatted-files.log
	FILES=`egrep '\.(js|scss)' auto-build.log`
	if [ ! -z "$FILES" ]; then
		echo converting tabs to spaces in changed .js, .scss files
		echo $FILES
		INDENT_TAB=0 INPLACE=1 ./scripts/fix-spaces.sh `egrep '\.(js|scss)' auto-build.log`

		npm run json5 && npm run allfix 2> /dev/null
#		npm run test:single 2>&1 | grep -v 'npm ERR!'
#		npm run test 2>&1 | grep -v 'npm ERR!'
#		npm run json5 && npm run lint 2> /dev/null
#		npm run json5 && npm run jscheck:config 2> /dev/null
	fi
fi
