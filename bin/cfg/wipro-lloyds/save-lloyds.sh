#!/bin/bash
# save my lloyds dev machine scripts to repo for safety

save-cfg.sh

WHOM=lloyds
OUT=~/workspace/bsac-cfg-cwa
BR=bsac-test

if [ "$COMPANY" == "$WHOM" ]; then
	echo Saving $COMPANY config to repository $OUT $BR for safe keeping
else
	echo This script is only for use on $WHOM computer.
	exit 1
fi


cp -r ~/bin $OUT
pushd $OUT > /dev/null
	git status
	echo You need to git add/commit/push changes from
	pwd
popd > /dev/null

