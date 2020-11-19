#!/usr/bin/env perl
# perl one liner version:
# perl -C -pe 's/&\#(\d+);/chr($1)/ge;s/&\#x([a-fA-F\d]+);/chr(hex($1))/ge;'
# WINDEV tool useful on windows development machine

use 5.012; # seamless utf
use strict;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Replace SGML/HTML/XML entities with utf8 characters from standard input.

# one-liner equivalent

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

See also grep-utf8.sh, utf*, unicode* and other unicode tools.

Example:

	echo '&#x1f433; &#42;' | $FindBin::Script

	Equivalent to perl oneliner command:

	perl -C -pe 's/&\\#(\\d+);/chr(\$1)/ge;s/&\\#x([a-fA-F\\d]+);/chr(hex(\$1))/ge;'

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

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

__END__
