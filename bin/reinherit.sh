#!/bin/bash
# reinherit symbolic links to a new directory.

DIR="${1:-.}"
FROM="$2"
TO="$3"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] from to [directory]

This will find symbolic links which link to the /from/ dir and relink them to the sibling /to/ dir

from       A partial directory path within a found symbolic link path to replace.
to         The new partial directory path to replace with.
directory  Optional. Defaults to current directory.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

This will find all symbolic links in the directory and replace /from/ substring with /to/ within the path to the symbolic link target.

See also wymlink.sh find-sum.sh

Example:

$cmd path include lib

Will change symbolic links from ../include/file.xxx to ../lib/file.xxx
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

if [ -z "$FROM" ]; then
	echo You must provide an interior sub path of a symbolic link search for.
	usage 2
fi

if [ -z "$TO" ]; then
	echo You must provide an interior sub path of a symbolic link to replace with.
	usage 3
fi

pushd "$DIR" > /dev/null && find . -type l -ls \
	| FROM="$FROM" TO="$TO" perl -ne '
		#print;
		chomp;
		s{\A.+?(\./)}{$1}xms;
		my ($name, $to) = split(/\s+->\s+/);
		#print qq{n:[$name] t:[$to]\n};
		#print qq{F:[$ENV{FROM}] T:[$ENV{TO}]\n};
		my $new = $to;
		$to =~ s{/$ENV{FROM}/}{/$ENV{TO}/}xms;
		if ($new ne $to)
		{
			my $cmd = qq{ln -sf "$to" "$name"\n};
			print $cmd;
			system($cmd);
		}
	'
popd > /dev/null
