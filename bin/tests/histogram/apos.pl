#!/usr/bin/perl

use utf8;
use locale;
use v5.16;
use strict;
use warnings;
use open qw(:std :utf8); # undeclared streams in UTF-8
use English;

my $apos = "'\N{U+149}\N{U+2bc}\N{U+2ee}\N{U+55a}\N{U+7f4}\N{U+7f5}\N{U+ff07}\N{U+e0027}";

foreach my $word (@ARGV)
{
	my $apos = chop($apos);
	print "$word${apos}s ";
}
print "\n";
