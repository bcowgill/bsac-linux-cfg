#!/bin/bash
# See also ls-pw.sh greppw.sh

TOP=/media/me
if [ `ls $TOP/*/PASSWDS.TXT | wc -l` == 0 ]; then
	for zip in $TOP/*/passwd.zip; do
		echo Extract from $zip
		dir=`dirname $zip`
		echo In dir $dir
		pushd $dir > /dev/null
			unzip passwd.zip
		popd > /dev/null
		vim $dir/PASSWDS.TXT
		exit $?
	done
else
	vim $TOP/*/PASSWDS.TXT
fi
