#!/bin/bash
# example of multiline search and replace to fix code issues:


if [ -z "$1" ]; then
	echo "
usage: $0 filename...

Perform multiple fixes to source code.

LINTFIX env var setting ...

Fixes:
	TODO describe your fixes here... 

Examples:

	for f in \`git grep -lE 'something'\`; do echo \$f; fix-multiline.sh \$f; done
"
	exit 1
fi

if [ ! -z "$2" ]; then
	while [ ! -z $1 ]; do
		$0 "$1"
		shift
	done
	exit 0
fi

cp $1 $1.bak
LINTFIX=${LINTFIX:-0} FILENAME="$1" perl -e '
	local $/ = undef;
	my $q = chr(39); # single quote
	my $Q = chr(34); # double quote
	my $OB = "{";

	my $filename = $ENV{FILENAME};
	$filename =~ s{\.\.?/}{}xmsg;  # bye to ./ ../
	$filename =~ s{\..+\z}{}xms; # bye to extension
	$filename =~ s{/index\z}{}xms; # strip if name is index.*
	$filename =~ s{\A .+ /}{}xms; # path is gone
	$filename = ucfirst($filename);

	$_ = <>;

	# // NOSONAR on a single line...
	s{\n(\ |\t)*(//\s*NOSONAR\s*?\n)}{ $2}xmsg;

	if ($ENV{LINTFIX})
	{
		s{,(\s*\))}{$1}xmsg;
	}

	print $_;
' $1.bak > $1
