#!/bin/bash
# Diff the windows lloyds versions of tools with the generic ones.

# Usage: diff-lloyds.sh [reverse|sync]

WHERE=~/workspace/projects/bsac-cfg-lloyds
O4B=~/workspace/projects/o4b/o4b-payments-cwa

DIFF="rvdiff.sh"
if [ -z "$1" ]; then
	DIFF="vdiff.sh"
else
	if [ "$1" == "sync" ]; then
		DIFF="xvdiff.sh"
	fi
fi

# DEBUG turn this on...
#DIFF="echo $DIFF"

function mydiff {
	local one two
	one="$1"
	two="$2"
	diff --brief "$one" "$two" || $DIFF "$one" "$two"
}

echo Lloyds Javascript tools
pushd ~/bin/template/javascript/legacy/o4b || exit 3

# Get the list of files that need to be diffed:
FILES=`find . -type f`

echo FILES=$FILES
for file in $FILES; do
	if [ -d $file ]; then
		echo skip directory $file
	else
		FILE=$O4B/$file
		if [ -f $FILE ]; then
			mydiff "$file" "$FILE"
		else
			echo no match for $file
		fi
	fi
done

popd

echo Lloyds win laptop config bin
pushd $WHERE/bin || exit 1

# Get the list of files that need to be diffed:
FILES=`ls -a1`
for file in $FILES; do
	if [ -d $file ]; then
		echo skip directory $file
	else
		FILE=~/bin/$file
		if [ -f $FILE ]; then
			mydiff "$file" "$FILE"
		else
			echo no match for $file
		fi
	fi
done

popd

echo Lloyds win laptop config
pushd $WHERE/bin/cfg/wipro-lloyds || exit 2


# Get the list of files that need to be diffed:
FILES=`ls -a1`

for file in $FILES; do
	if [ -d $file ]; then
		echo skip directory $file
	else
		FILE=~/$file
		if [ -f $FILE ]; then
			mydiff "$file" "$FILE"
		else
			FILE=~/bin/$file
			if [ -f $FILE ]; then
				mydiff "$file" "$FILE"
			else
				echo no match for $file
			fi
		fi
	fi
done

mydiff home/oh-my-git-aliases.sh ~/.git_aliases

popd

