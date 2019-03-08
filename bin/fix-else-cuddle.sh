#!/bin/bash
# multiline search/replace to fix else statements which should be cuddled
# }
# else {
#
# } else {

# }
# // comment
# else {
#
# } else {
#   // comment

# find files which need fixing and fix them.
# for file in `ggr else app/ | grep -v '}' | perl -pne 's{:.+\n}{\n}xmsg' | sort | uniq`; do echo $file; INDENT=2 fix-else-cuddle.sh $file; done

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

	my $INDENT = $ENV{INDENT} ? (" " x $ENV{INDENT}) : "\t";

	$_ = <>;

	s{
		(\n \s* $c) \s*?
		\n (\s*//[^\n]+)
		\n \s*? (else [^$o]+ $o)
	}{
		"$1 $3\n$INDENT$2"
	}xmsge;

	s{
		(\n \s* $c) \s*?
		\n \s*? else
	}{
		"$1 else"
	}xmsge;

	print $_;

' $1.bak > $1
