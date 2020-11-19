#!/bin/bash
# find the authors of shameful git commit messages up to the date provided
# WINDEV tool useful on windows development machine

STOP=$1
LEN=${2:-22}

if [ -z "$STOP" ]; then
	echo "
usage: $(basename $0) YYYY-MM-DD [length]

This will display shamefully short git log messages until a certain date is reached.
"
	exit 1
fi

# Example of what we are parsing, from the git log
# Author: Brent Cowgill <brent.cowgill@ontology.com>
# Date:   Mon Dec 16 09:56:59 2013 +0000
#
#     additions to files to backup to dropbox for WFH possibilities
# --

git log \
	| egrep -A3 '^Author:\s' \
	| STOP=$STOP LEN=$LEN perl -ne '
		BEGIN {
			$ENV{STOP} =~ m{(\d+)-(\d+)-(\d+)}xms;
			$D=$3;
			$M=qw(Jan Feb Mar Apr Jun Jul Aug Sep Oct Nov Dec)[$2-1];
			$Y=$1;
			#print "$ENV{STOP} until $Y $M $D\n";
		}
		chomp;
		if (s{\AAuthor:\s}{}xms)
		{
			$author = $_;
			$author =~ s{\s+<.+>}{}xms
		}
		elsif (s{\ADate:\s+}{}xms)
		{
			exit 0 if $_ !~ m{\s$Y}xms;
			if (m{$M\s+(\d+)}xms)
			{
				$endmonth = 1;
				exit 0 if $1 < $D;
			}
			elsif ($endmonth)
			{
				exit 0;
			}
		}
		elsif (s{\A\s+(\S)}{$1}xms)
		{
			$msg = $_;
			s{\A\w+\s*}{}xms;
			s{[A-Z]{2,}-\d+\s*}{}xms;
			print "$author: $msg\n" if length($_) < ($ENV{LEN} || 22)
		}
	'
