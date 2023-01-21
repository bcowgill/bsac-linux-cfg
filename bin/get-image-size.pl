#!/usr/bin/env perl

# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use FindBin;
use English -no_match_vars;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = 0;

my $find = $ENV{FIND};
my $rhSizes = {};

sub usage
{
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?]

This program will parse stdin for image sizes like 32x45 or 12 x 13 and work out various image dimensions for the entire collection.
It prints out dimensions and aspect ratio for each property, or if only one property is wanted, just the dimensions of that image property.

FIND    environment variable to specify a single image resolution to output.
--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

The image properties computed are:

min       The minimum image width and image height seen in the collection.  An image this size is guaranteed to fit within every image in the collection.

max       The maximum image width and image height seen in the collection.  Every image in the collection is guaranteed to fit within these dimensions.

average   The average image width and height seen in the collection.

small     The smallest image dimensions (by area) seen in the collection.

big       The largest image dimensions (by area) seen in the collection.

thin      The dimensions of the image with the smallest width in the collection.

fat       The dimensions of the image with the largest width in the collection.

short     The dimensions of the image with the smallest height in the collection.

tall      The dimensions of the image with the largest height in the collection.

portrait  The dimensions of the image which is the most like a skyscraper, that is, with the smallest aspect ratio.

landscape The dimensions of the image which is the most like a sausage, that is, with the largest aspect ratio.

square    The dimensions of the image which is the most square, that is, closest to an aspect ratio of 1.

See also filter-images.sh image-crop-rotate.sh image-sort-resize.sh imgcat.sh label-photo.sh ls-camera.sh ls-meta.sh viewimg.sh identify display convert

Example:

For the entire collection of .png files, print out all the image properties computed.

    file *.png | $cmd

Find the maximum dimensions of the collection of .png image files.

    file *.png | FIND=max $cmd

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

sub aspect
{
	my ($width, $height) = @ARG;
	$height++ unless $height;
	my $aspect = $width / $height;
	return $aspect;
}

sub maximum
{
	my ($width, $height, $w, $h) = @ARG;
	$width = $width > $w ? $width : $w;
	$height = $height > $h ? $height : $h;
	return ($width, $height);
}

sub minimum
{
	my ($width, $height, $w, $h) = @ARG;
	$width = $width < $w ? $width : $w;
	$height = $height < $h ? $height : $h;
	return ($width, $height);
}

sub average
{
	my ($width, $height) = @ARG;
	$rhSizes->{average}{sum_width} += $width;
	$rhSizes->{average}{sum_height} += $height;
	$rhSizes->{average}{number}++;

	$width  = $rhSizes->{average}{sum_width} / $rhSizes->{average}{number};
	$height = $rhSizes->{average}{sum_height} / $rhSizes->{average}{number};

	return (int($width + 0.5), int($height + 0.5));
}

sub biggest
{
	my ($width, $height, $w, $h) = @ARG;
	my ($area, $a) = ($width * $height, $w * $h);
	$width = $area > $a ? $width : $w;
	$height = $area > $a ? $height : $h;
	return ($width, $height);
}

sub smallest
{
	my ($width, $height, $w, $h) = @ARG;
	my ($area, $a) = ($width * $height, $w * $h);
	$width = $area < $a ? $width : $w;
	$height = $area < $a ? $height : $h;
	return ($width, $height);
}

sub fattest
{
	my ($width, $height, $w, $h) = @ARG;
	my ($size, $s) = ($width, $w);
	$width = $size > $s ? $width : $w;
	$height = $size > $s ? $height : $h;
	return ($width, $height);
}

sub thinnest
{
	my ($width, $height, $w, $h) = @ARG;
	my ($size, $s) = ($width, $w);
	$width = $size < $s ? $width : $w;
	$height = $size < $s ? $height : $h;
	return ($width, $height);
}

sub tallest
{
	my ($width, $height, $w, $h) = @ARG;
	my ($size, $s) = ($height, $h);
	$width = $size > $s ? $width : $w;
	$height = $size > $s ? $height : $h;
	return ($width, $height);
}

sub shortest
{
	my ($width, $height, $w, $h) = @ARG;
	my ($size, $s) = ($height, $h);
	$width = $size < $s ? $width : $w;
	$height = $size < $s ? $height : $h;
	return ($width, $height);
}

sub portrait
{
	my ($width, $height, $w, $h) = @ARG;

	my ($size, $s) = (aspect($width,$height), aspect($w,$h));
	$width = $size < $s ? $width : $w;
	$height = $size < $s ? $height : $h;
	return ($width, $height);
}

sub landscape
{
	my ($width, $height, $w, $h) = @ARG;

	my ($size, $s) = (aspect($width,$height), aspect($w,$h));
	$width = $size > $s ? $width : $w;
	$height = $size > $s ? $height : $h;
	return ($width, $height);
}

sub square
{
	my ($aspect) = @ARG;
	return abs(1 - $aspect);
}

sub squarest
{
	my ($width, $height, $w, $h) = @ARG;

	my ($size, $s) = (square(aspect($width,$height)), square(aspect($w,$h)));
	$width = $size < $s ? $width : $w;
	$height = $size < $s ? $height : $h;
	return ($width, $height);
}

sub update
{
	my ($key, $width, $height, $cmp) = @ARG;

	if ($rhSizes->{$key})
	{
		my ($w, $h) = ($rhSizes->{$key}{width}, $rhSizes->{$key}{height});
		($width, $height) = $cmp->($width, $height, $w, $h);
	}
	$rhSizes->{$key}{width} = 0 + $width;
	$rhSizes->{$key}{height} = 0 + $height;
}

my @Order = qw(
	min max average small big thin fat short tall portrait landscape square
);

sub found_size
{
	my ($width, $height) = @ARG;
	update('min', $width, $height, \&minimum);
	update('max', $width, $height, \&maximum);
	update('average', $width, $height, \&average);
	update('small', $width, $height, \&smallest);
	update('big', $width, $height, \&biggest);
	update('thin', $width, $height, \&thinnest);
	update('fat', $width, $height, \&fattest);
	update('short', $width, $height, \&shortest);
	update('tall', $width, $height, \&tallest);
	update('portrait', $width, $height, \&portrait);
	update('landscape', $width, $height, \&landscape);
	update('square', $width, $height, \&squarest);
}

while (my $line = <>)
{
	$line =~ s{(\d+)\s*x\s*(\d+)}{found_size($1, $2)}xmsge;
}

print Dumper($rhSizes) if $DEBUG;
if ($find && $rhSizes->{$find})
{
	print "$rhSizes->{$find}{width}x$rhSizes->{$find}{height}\n";
}
else
{
	foreach my $type (@Order)
	{
		my ($width, $height) = ($rhSizes->{$type}{width}, $rhSizes->{$type}{height});
		my $h = $height;
		$h++ unless $h;
		my $aspect = $width / $h;
		print "$type: ${width}x$height $aspect\n";
	}
}

__END__
identify standard-particle-model.png
standard-particle-model.png PNG 945x626 945x626+0+0 8-bit DirectClass 1.367MB 0.000u 0:00.000
file standard-particle-model.png
standard-particle-model.png: PNG image data, 1945 x 26, 8-bit/color RGBA, non-interlaced
