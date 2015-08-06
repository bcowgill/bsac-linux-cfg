#!/bin/bash
# check all my git repos for uncommitted changes and remote updates
# or all repos under a given directory

TOP=$HOME
#DO=not

if [ `hostname` == WYATT ]; then
	TOP=/cygdrive/d/d/s
fi

if [ ! -z $1 ]; then
	TOP="$1"
fi

pushd $TOP > /dev/null
REPOS=`find . -type d -name .git | grep -v .rvm/gems/ | grep -v .bundler/ruby/ | grep -v /.grunt-init/ | grep -v Soda | perl -pne 's{\.git \s* \z}{\n}xms;'`
if [ `hostname` == WYATT ]; then
	REPOS="$HOME $REPOS"
fi
if [ ${DO:-doit} == 'not' ]; then
	for dir in $REPOS
	do
		echo $dir
	done
	REPOS=
else
	echo $REPOS
fi

for dir in $REPOS
do
	pushd "$dir" > /dev/null
	perl -e 'print(("=" x 78) . "\n")'
	if git status | grep 'nothing to commit, working directory clean' > /dev/null; then
		echo `pwd` no changes
		git fetch && git pull
	else
		pwd
		git status
		echo `pwd` will not try to pull from remote
	fi
	popd > /dev/null
done
popd > /dev/null

