#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# take a pasted list of items one per line and spit it out as comma separated on a single line.
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);

my $input;
local $INPUT_RECORD_SEPARATOR = undef;
$input = <STDIN>;
$input =~ s{\s*,?\s*\n}{,}xmsg;
$input =~ s{,\z}{}xmsg;
$input =~ s{\A,}{}xmsg;
print "$input\n";

__END__
Example pasted data:
2G_Diepsloot_Mall_SGC,

2G_Olivenhoutbosch_SGC,

3G_Blue_Hills_Mobile_SGC,

3G_Saddlebrook_MN1_SGC,


