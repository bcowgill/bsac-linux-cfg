#!/usr/bin/env perl
# utf82hex.pl
# output utf8 characters as {U+XXXX} code points

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full);
binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	print << "USAGE";
Usage:
$0 [filename]

Read utf8 from STDIN or files and show characters as {U+XXXX} if they
are U+0100 or higher.
USAGE
	exit(0);
}

if (scalar(@ARGV)) {
	print map {
		convert($ARG);
	} @ARGV;
}
else
{
	while (my $line = <>)
	{
		print convert($line);
	}
}

sub convert
{
	join("",
	map {
		toCodePoint($ARG);
	} unpack("W*", $ARG[0])); # unpack Unicode characters
}

sub toCodePoint
{
	return $ARG > 128                 ## if wide character...
		? sprintf("{U+%04X}", $ARG)   ## {U+....}
		: chr($ARG);                  ## return as is
}