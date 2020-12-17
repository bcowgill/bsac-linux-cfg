#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# utf8codept.pl
# output utf8 characters as {U+XXXX} code points
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full);
use FindBin;

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

my $SPACE = 32;
my $TAB = 9;
my $LINE_FEED = 10;
my $CARRIAGE_RETURN = 13;

my $MIN_CODE_PT = 126;
my $MIN_CODE = toUTFCodePoint($MIN_CODE_PT);

my $MAX_CTRL = toUTFCodePoint($SPACE);
my $CTRL = "@{[toUTFCodePoint($TAB)]} @{[toUTFCodePoint($LINE_FEED)]} @{[toUTFCodePoint($CARRIAGE_RETURN)]}";

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	my $cmd = $FindBin::Script;

	print << "USAGE";
usage: $cmd [filename]

Read utf8 from STDIN or files and show characters as {U+XXXX} if they are a control character or $MIN_CODE or higher.  A control character is any code point below $MAX_CTRL except tab, line feed, carriage return: $CTRL

EXAMPLES:
	head -3000 ~/bin/data/unicode/unicode-names.txt | tail -1 | $cmd

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
	return $ARG[0] > $MIN_CODE_PT       ## if wide character...
		? toUTFCodePoint($ARG[0])        ## {U+....}
		: encodeControl($ARG[0]);        ## encode only if control character
}

sub encodeControl
{
	return isControl($ARG[0]) ? toUTFCodePoint($ARG[0]) : chr($ARG[0])
}

# low value codes except tab, line feed and carriage return
sub isControl
{
	return $ARG[0] < $SPACE && $ARG[0] != $TAB && $ARG[0] != $LINE_FEED && $ARG[0] != $CARRIAGE_RETURN;
}

sub toUTFCodePoint
{
	return sprintf("{U+%04X}", $ARG[0]);
}
