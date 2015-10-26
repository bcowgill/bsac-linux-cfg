#!/usr/bin/env perl
# utf8dbg.pl
# debug some utf8 character as perl sees it.

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full);
use Devel::Peek;

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	print << "USAGE";
Usage:
$0 utf8 characters

Read utf8 from STDIN or files and show what perl thinks about it internally.
USAGE
	exit(0);
}

if (scalar(@ARGV)) {
	foreach my $string (@ARGV) {
		debug($string);
	}
}
else
{
	while (my $line = <>)
	{
		debug($line);
	}
}

sub debug
{
	my $string = $ARG[0];
	print("[$string]: is_utf8? ", utf8::is_utf8($string) ? 1: 0, "\n");
	my @chars = split('', $string);
	foreach my $char (@chars)
	{
		print("[$char]: bytes[@{[toBytes($char)]}] @{[toCodePoint($char)]} @{[toName($char)]}\n");
		Dump($char);
	}
}

sub toCodePoint
{
	my $val = unpack("W", $ARG[0]);
	return $val > 128                 ## if wide character...
		? $val . " " . sprintf("U+%04X", $val)     ## {U+....}
		: $val;                  ## return as is
}

sub toBytes
{
	return join(" ", unpack("U0(H2)*", $ARG[0]));
}

sub toName
{
	my $val = unpack("W", $ARG[0]);
	return "\\N{" . charnames::viacode($val) . "}";
}
