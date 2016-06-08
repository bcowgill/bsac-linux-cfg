#!/bin/bash
# fix up code after a save

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
	if [ ! -z "$FILES" ]; then
		echo converting tabs to spaces in changed .js files
		echo $FILES
		INDENT_TAB=0 INPLACE=1 fix-spaces.sh `egrep \.js auto-build.log`

		npm run jsfix
	fi
fi
