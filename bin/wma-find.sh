#!/bin/bash
# find .wma files which have not been converted to .mp3 files.
# x.wma - look for x.mp3
# .../wma/.../x.wma - look for .../mp3/.../x.mp3
# .../wma/.../x.wma - look for .../.../x.mp3
#
# wma-find.sh > convert.lst
# perl -ne 'chomp; $_ = qq{wma2mp3dir.sh $_}; system qq{$_\n}' convert.lst

DIR=${1:-.}

find $DIR -type f -name '*.wma' | \
	perl -ne '
	chomp;
	my $mp3 = $_;
	$mp3 =~ s{\.wma}{.mp3}xmsi;
	next if -f $mp3;

	$mp3 =~ s{/wma/}{/mp3/}xmsi;
	next if -f $mp3;

	$mp3 =~ s{/mp3/}{/}xmsi;
	next if -f $mp3;

	print qq{"$_"\n}
'
