#!/usr/bin/env perl
# choose a random up to N lines from standard input
srand;

my $MAX = shift || 1;
my ($line, @Lines);

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
