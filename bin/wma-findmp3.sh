#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# find .wma files that have a corresponding mp3 file and show the mp3 as well.
# x.wma - look for x.mp3
# .../wma/.../x.wma - look for .../mp3/.../x.mp3
# .../wma/.../x.wma - look for .../.../x.mp3

DIR=${1:-.}

find $DIR -type f -name '*.wma' | \
	perl -ne '
	chomp;
	my $mp3 = $_;
	$mp3 =~ s{\.wma}{.mp3}xmsi;
	if (-f $mp3) {
		print qq{"$_"\n"$mp3"\n\n};
		next;
	}

	$mp3 =~ s{/wma/}{/mp3/}xmsi;
	if (-f $mp3) {
		print qq{"$_"\n"$mp3"\n\n};
		next;
	}

	$mp3 =~ s{/mp3/}{/}xmsi;
	if (-f $mp3) {
		print qq{"$_"\n"$mp3"\n\n};
		next;
	}
'
