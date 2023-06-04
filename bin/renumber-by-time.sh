#!/bin/bash
# Renumber/rename screen shot files by their timestamp.

TEST=1
if [ "$1" == "--go" ]; then
	TEST=
	shift
fi
PREFIX="$1"
EXT="${2:-png}"
if [ "$3" == "--go" ]; then
	TEST=
fi

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--go] [prefix] [extension]

Renumber or rename files which may already have numbers in them by timestamp.

prefix    optional New file name prefix for numbered files.
extension optional File extension for files to rename. defaults to $EXT
--go      Make it so.  Default is to show what would happen but not do it.
--man     Shows help for this tool.
--help    Shows help for this tool.
-?        Shows help for this tool.

Creates a temporary directory 'done' to move the files to and a go.sh shell script to do the moving.

See also renumber-files.sh, rename-files.sh, auto-rename.pl, choose.pl, cp-random.pl mv-spelling.pl mv-to-year.sh mv-camera.sh rename-podcast.sh

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

GO=
[ "$TEST" == 1 ] && GO=-a

mkdir -p done
ls -rt | grep png | \
	EXT="$EXT" PREFIX="$PREFIX" perl -pne '
	chomp;
	my $in = $_;
	my $out = $ENV{PREFIX} ? "$ENV{PREFIX}.$ENV{EXT}" : $_;
	++$num;
	$num = "0$num" if length($num) < 2;
	$out =~ s{(-\d+)?(\.$ENV{EXT})}{-0$num$2}xms;
	$_ = qq{mv "$in" "done/$out"\n};
' | tee $GO go.sh

[ "$TEST" == 1 ] && echo TEST mode, did not make any changes. Run ./go.sh to make changes if all looks well.

chmod +x go.sh
if [ -z "$TEST" ]; then
	./go.sh
	mv done/*.$EXT .
	rmdir done
fi
