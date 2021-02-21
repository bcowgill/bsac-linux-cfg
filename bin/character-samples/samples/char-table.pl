#!/usr/bin/env perl
# print out a character table of 256 characters in 16x16 columns.
# ./char-table.pl 8192 | tee char-table-2000.txt

use utf8;
use v5.16;
use strict;
use warnings;
use warnings qw(FATAL utf8);
use open qw(:std :utf8); # undeclared streams in UTF-8

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $gap = '   ';
my @columns = qw(0 1 2 3 4 5 6 7 8 9 A B C D E F);

my %Hide = ();

foreach my $code (0, 5, 7 .. 15, 142, 143) {
	$Hide{$code} = 3;
}

# For image-magick these characters cause problems being drawn as text.
#foreach my $code (0 .. 31) {
#	$Hide{$code} = 3;
#}

foreach my $code (768 .. 879, 1155 .. 1161, 1473, 1474, 1476, 1477, 1479) {
	$Hide{$code} = -2;
}

sub char
{
	my ($code) = @ARG;
	my $spaces = $Hide{$code} || 0;
	return (' ' . chr($code) . (' ' x -$spaces)) if $spaces < 0;
	return $spaces ? (' ' x $spaces) : chr($code) . '  ';
}

my $start = shift || 0;

#print Dumper(\%Hide);

printf "%04x  ", $start;
print join($gap, @columns) . "\n";

foreach my $row (@columns)
{
	printf "%04X ", $start;
	foreach my $row (@columns)
	{
		my $char = char($start);
		$start++;
		print " $char";
	}
	printf " %04X @{[$start - 1]}\n", ($start - 1);
}
printf "%04X $start\n", $start;
