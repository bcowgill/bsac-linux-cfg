#!/usr/bin/perl

use utf8;
use locale;
use v5.16;
use strict;
use warnings;
use open qw(:std :utf8); # undeclared streams in UTF-8

my $spc = " \N{U+08}\xa0\N{U+1361}\N{U+1680}\N{U+2000}\N{U+2001}\N{U+2002}\N{U+2003}\N{U+2004}\N{U+2005}\N{U+2006}\N{U+2007}\N{U+2008}\N{U+2009}\N{U+200a}\N{U+200b}\N{U+202f}\N{U+205f}\N{U+2408}\N{U+2420}\N{U+3000}\N{U+303f}\N{U+feff}\N{U+e0020}";
my $stuff = join(" ", @ARGV);
print "$spc$stuff$spc\n";
