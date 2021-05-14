#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [file ...]

Show css color and inverse color from standard input or files.

file    files to process instead of standard input.
--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

More detail ...

# See also all-debug-css.sh, css-diagnose.sh, debug-css.sh, css-color-scale.pl, filter-css-colors.pl, find-css.sh, invert-css-color.pl

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

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

__END__
