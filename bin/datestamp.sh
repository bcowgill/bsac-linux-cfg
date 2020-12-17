#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# output an rfc-3339 timestamp. or something close
# 2017-11-07 12:32:52+00:00
# WINDEV tool useful on windows development machine
if date --rfc-3339=seconds 2> /dev/null; then
	exit 0
else
	# windows and Mac
#	date '+%Y-%m-%d %H:%M:%S%:z' on linux it would be
	date '+%Y-%m-%d %H:%M:%S%z' | perl -pne 's{(\d\d \s*) \z}{:$1}xmsg'
fi
exit
# fall back to perl
perl -MPOSIX -e '
	my $z = strftime("%z", localtime);
	$z =~ s{(\d)(\d\d)\z}{$1:$2}xms;
	my $date = strftime("%Y-%m-%d %H:%M:%S$z\n",localtime);
	print $date;
'
exit
