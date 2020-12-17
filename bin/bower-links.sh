#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show bower links for local project or a specific directory.
# you need to be above the bower_components dir for this to work.
# usage bower-links.sh [dir]

DIR=${1:-.}
BOWER_DIR=$HOME/.local/share/bower/links
echo $BOWER_DIR
ls -al $BOWER_DIR

for path in `find $DIR -name bower_components`
do
	( echo $path; \
		ls -al $path | grep lrwx ) | grep -B 1 -- '->'
done

