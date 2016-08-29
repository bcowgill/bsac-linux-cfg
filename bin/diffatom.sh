#!/bin/bash
# diff current atom config files with the git controlled ones

pushd ~/bin/cfg/.atom/

for file in `find . -type f | sort`
do
	#touch "$HOME/.atom/$file"
	diff.sh "$HOME/.atom/$file" "$file" $1
done
popd

