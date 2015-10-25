#!/usr/bin/env perl
# replace SGML/HTML/XML entities with utf8 characters

# one-liner equivalent
# perl -C -pe 's/&\#(\d+);/chr($1)/ge;s/&\#x([a-fA-F\d]+);/chr(hex($1))/ge;'

use 5.012; # seamless utf
use strict;

binmode(STDIN, ":encoding(utf8)");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

while (my $line = <>)
{
	$line =~ s{
		& \# (\d+) ;
	}{
		chr($1)
	}xmsge;
	$line =~ s{
		& \# x ([a-fA-F\d]+) ;
	}{
		chr(hex($1))
	}xmsge;
	print $line;
}

