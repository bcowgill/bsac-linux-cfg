#!/bin/bash
# fix up NOSONAR markers

if [ -z "$1" ]; then
	for f in `git grep -l NOSONAR`; do ./fix-sonar.sh $f; done
	exit 0
fi

if [ ! -z "$2" ]; then
	while [ ! -z $1 ]; do
		$0 "$1"
		shift
	done
	exit 0
fi

cp $1 $1.bak
FILENAME="$1" perl -e '
	local $/ = undef;
	$_ = <>;

	# // NOSONAR on a single line...
	s{\n(\ |\t)*(//\s*NOSONAR\s*?\n)}{ $2}xmsg;

	print $_;
' $1.bak > $1
