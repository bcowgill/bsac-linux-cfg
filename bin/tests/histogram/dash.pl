#!/usr/bin/perl

use utf8;
use locale;
use v5.16;
use strict;
use warnings;
use open qw(:std :utf8); # undeclared streams in UTF-8
use English;

my $dash = "-\N{U+58a}\N{U+5be}\N{U+1400}\N{U+1806}\N{U+2010}\N{U+2011}\N{U+2012}\N{U+2013}\N{U+2014}\N{U+2015}\N{U+2053}\N{U+2e17}\N{U+2e1a}\N{U+2e3a}\N{U+2e3b}\N{U+301c}\N{U+3030}\N{U+30a0}\N{U+fe31}\N{U+fe32}\N{U+fe58}\N{U+fe63}\N{U+ff0d}";

foreach my $word (@ARGV)
{
	my $dash = chop($dash);
	print "$word$dash";
}
print "finis\n";
