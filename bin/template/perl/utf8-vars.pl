#!/usr/bin/env perl
# sample using unicode for variables

use 5.012; # seamless utf8 support
use utf8;  # allow utf8 variables
use strict;

while (my $ƏƔƖ = <>)
{
	print $ƏƔƖ;
}
