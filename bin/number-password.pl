#!/usr/bin/env perl
# convert a complicated password into just a set of numbers for use on a tv or something.
use strict;
use warnings;

while (<>)
{
	chomp;
	print join('', map { ord($_)} split('', $_)) . "\n";
}
