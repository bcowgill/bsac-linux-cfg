#!/bin/bash
# multiline search/replace to fix else statements which should be cuddled
# }
# else {
#
# } else {

# find files which need fixing and fix them.
# for file in `ggr else app/ | grep -v '}' | perl -pne 's{:.+\n}{\n}xmsg' | sort | uniq`; do echo $file; fix-else-cuddle.sh $file; done

if [ ! -z "$2" ]; then
	for FILE in $*
	do
		$0 $FILE
	done
	exit $?
fi

cp "$1" "$1.bak"
FILE="$1" perl -e '
	use strict;
	use warnings;
	use Data::Dumper;

	local $/ = undef;
	my $q = chr(39);
	my $Q = chr(34);
	my $o = "{";
	my $c = "}";
	my $DEBUG = 0;

	$_ = <>;

	s{
		(\n \s* $c) \s*? 
		\n \s*? else
	}{
		"$1 else"
	}xmsge;

	print $_;

' $1.bak > $1
