#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use English;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Display some text from standard input in a 78 column wide banner line.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

example:

echo filename | $FindBin::Script
datestamp.sh | $FindBin::Script

See also datestamp.sh
USAGE
	exit 0;
}

if ($ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

local $INPUT_RECORD_SEPARATOR = undef;
my $text = <>;
$text =~ s{\s+}{ }xmsg;
if (length($text) >= 78 - length("===  =========="))
{
	print(join("\n", (("=" x 78) , $text , "")));
}
else
{
	my $text = "=== $text ";
	print($text . ("=" x (78 - length($text))) . "\n");
}

__END__
Sample output:
=== this is a test  ==========================================================

==============================================================================
this is too long for one line so it gets a separate banner line
