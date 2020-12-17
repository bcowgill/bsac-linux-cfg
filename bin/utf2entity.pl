#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# replace non-ASCII characters with SGML/HTML/XML entities

# one-liner equivalent
# perl -C -pe 's/([^\x00-\x7f])/sprintf("&#%d;", ord($1))/ge;'
# WINDEV tool useful on windows development machine

use 5.012; # seamless utf
use strict;

# will validate that input is utf8
binmode(STDIN, ":encoding(utf8)");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

while (my $line = <>)
{
	$line =~ s{
		([^\x00-\x7f])
	}{
		sprintf("&#%d;", ord($1))
	}xmsge;
	print $line;
}
