#!/bin/bash
# multiline search/replace to fix javascript test plan by wrapping
# the outermost describe in the file with the filename

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
	my $DEBUG = 0;

	$_ = <>;

	# wrap first describe with file name
	s{
		(describe\()
	}{
		"$1$q$ENV{FILE}$q, function descSuiteFileName () \{\n$1"
	}xmse;

	# handle closing describe, assuming in first col
	s{
		(\n\}\)\;)
	}{
		"$1$1 // descSuiteFileName"
	}xmse;

	print $_;

' $1.bak > $1
