#!/usr/bin/env perl
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# read filenames from standard input and update file timestamp to within the last 90 days

use strict;
use warnings;
use File::stat;
use Time::Local;
use Time::localtime;
use Time::Piece;
use Data::Dumper;
use Time::Seconds;

my $DAYS = 90;

foreach my $filename (<STDIN>) {
	chomp($filename);

	eval {
		my $filedate = Time::Piece->new(stat($filename)->mtime);
		my $rightnow = localtime;
		my $daysago = int($DAYS * rand());
		my $then = $rightnow - (ONE_DAY * $daysago);

		my $newtime = Time::Piece->new(
			timelocal(
				$filedate->sec,
				$filedate->min,
				$filedate->hour,
				$then->mday,
				$then->mon - 1,
				$then->year
			));

		print qq{$filename @{[$newtime->datetime]}\n};
		system qq{touch "$filename" --date=@{[$newtime->datetime]}};
	};
	if ($@) {
		print STDERR qq{$filename $@\n};
	}
}
