#!/usr/bin/env perl
# show css color and inverse color from standard input

use strict;
use warnings;
use English;

my %remap = qw(
	white fff
	yellow ff0
	green 0f0
	red f00
);
my $colors = join('|', keys(%remap));

while (my $line = <>)
{
	$line =~ s{((rgba?\() \s* (\d+) \s* , \s* (\d+) \s* , \s* (\d+)) .+}{qq{\t"$1" => "$2} . invert_rgb($3, $4, $5) . qq{",\n}}xmsgei;
	$line =~ s{(\#[0-9a-f]+)}{qq{\t"$1" => "} . invert_color($1) . qq{",}}xmsgei;
	$line =~ s[($colors)][qq{\t"$1" => "#} . invert_color($remap{$1}) . qq{",}]xmsge;
#	$line =~ s{((rgba?\() \s* (\d+) \s* , \s* (\d+) \s* , \s* (\d+))}{"s{\\Q$1\\E}{$2" . invert_rgb($3, $4, $5) . "}xmsg;"}xmsgei;
#	$line =~ s{(\#[0-9a-f]+)}{"s{\\$1}{\\" . invert_color($1) . "}xmsg;"}xmsgei;
#	$line =~ s[($colors)]["s{$1}{\\#" . invert_color($remap{$1}) . "}xmsg;"]xmsge;
	print $line;
}

sub invert_rgb
{
	my ($red, $green, $blue) = @ARG;
	$red = 255 - $red;
	$green = 255 - $green;
	$blue = 255 - $blue;
	return "$red, $green, $blue";
}

sub invert_color
{
	my ($color) = @ARG;
	$color =~ tr[0123456789abcdefABCDEF][fedcba9876543210543210];
	return $color;
}
