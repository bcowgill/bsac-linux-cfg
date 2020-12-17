#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
export START=$1
shift
export END=$1
shift
export CONTENT=$1
shift

if [ -z "$1" ]; then
	cat <<EOF
usage: $(basename $0) start end content file ...

This script will grep a file for a section marked by an open and close marker and then inject the content from another file into it.

See also after.sh, middle.sh, between.sh, prepend.sh, until.sh

example:

$(basename $0) '\#WORKSPACEDEF\n' '\#/WORKSPACEDEF\n' content filename
EOF
	exit 1
fi

#echo $START to $END
#echo $CONTENT
#echo $*

perl -e '
	BEGIN
	{
		local $/ = undef;
		my $fh;
		open($fh, "<", $ENV{CONTENT}) || die "content file <$ENV{CONTENT}>: $!";
		$content = <$fh>;
		close($fh);
	}

	foreach my $file (@ARGV)
	{
		local $/ = undef;
		print "injecting content into $file\n";
		my $fh;
		open($fh, "<", $file) || die "target file <$file>: $!";
		my $target = <$fh>;
		close($fh);

		if ($target =~ s{($ENV{START}) .* ($ENV{END}) }{$1$content$2}xms)
		{
			open($fh, ">", $file) || die "target file <$file>: $!";
			print $fh $target;
			close($fh);
		}
		else
		{
			warn("Did not find markers $ENV{START} .. $ENV{END} in $file");
		}
	}
' $*
