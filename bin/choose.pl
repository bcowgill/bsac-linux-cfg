#!/usr/bin/env perl
# choose a random up to N lines from standard input
# WINDEV tool useful on windows development machine

use FindBin;

srand;

my $MAX = shift || 1;
my ($line, @Lines);

if ( $MAX eq "--help" )
{
	print <<"USAGE";
usage:
$FindBin::Script [number] [file ...]

Choose lines randomly from file or standard input. If the number is given that many consecutive lines will be chosen otherwise only one line is chosen.

See also cp-random.pl
USAGE
	exit 1;
}

while (<>)
{
	if (rand($.) < 1)
	{
		@Lines = ($_);
		$line = $_;
	}
	else
	{
		if ($line)
		{
			push(@Lines, $_) unless scalar(@Lines) >= $MAX;
		}
	}
}

splice(@Lines, $MAX) if scalar(@Lines) > $MAX;
die "FAILED" unless scalar(@Lines <= $MAX);
print join('', @Lines);
