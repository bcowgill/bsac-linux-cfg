#!/bin/bash
# Diff the windows lloyds versions of tools with the generic ones.


WHERE=~/workspace/projects/bsac-cfg-lloyds

DIFF="rvdiff.sh"
if [ -z "$1" ]; then
	DIFF="vdiff.sh"
fi

# DEBUG turn this on...
#DIFF="echo $DIFF"

function mydiff {
	local one two
	one="$1"
	two="$2"
	diff --brief "$one" "$two" || $DIFF "$one" "$two"
}

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

pushd cfg/wipro-lloyds || exit 2


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
