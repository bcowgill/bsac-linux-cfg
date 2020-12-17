#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# take a pasted list of items one per line and spit it out as a javascript array of strings one per line
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);

my @Lines = ();
while (my $input = <>)
{
	next if $input =~ m{\A \s* \z}xms;
	$input =~ s{\A\s*}{}xmsg;
	$input =~ s{\s*\z}{}xmsg;

	if ($input =~ m{'}xms)
	{
		$input =~ s{'}{\\'}xmsg;
		$input = qq{'$input'};
	}
	else
	{
		$input = qq{'$input'};
	}

	push(@Lines, $input);
}
print "[\n" . join(",\n", @Lines) . "\n]\n";

__END__
Example pasted data:

https://maps.gstatic.com/mapfiles/ms2/micons/ylw-pushpin.png

https://maps.gstatic.com/mapfiles/ms2/micons/purple-pushpin.png

https://maps.gstatic.com/mapfiles/ms2/micons/pink-pushpin.png
