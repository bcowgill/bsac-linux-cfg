#!/bin/bash
# CUSTOM some custom changes must be made to use this on different files.

TEST=1

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

Renumber files which may already have numbers in them by timestamp.
Needs custom configuration to work defaults to .png files only.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also renumber-files.sh, rename-files.sh, auto-rename.pl, choose.pl, cp-random.pl

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

[ "$TEST" == 1 ] && echo TEST mode, will not make any changes.
GO=
[ "$TEST" == 1 ] && GO=--append

mkdir -p done
ls -rt | grep png | \
	perl -pne '
	chomp;
	my $in = $_;
	my $out = $_;
	++$num;
	$num = "0$num" if length($num) < 2;
	$out =~ s{(-\d+)?(\.png)}{-0$num$2}xms;
	$_ = qq{mv $in done/$out\n};
' | tee $GO go.sh
chmod +x go.sh
if [ -z "$TEST" ]; then
	./go.sh
	mv done/*.png .
fi
