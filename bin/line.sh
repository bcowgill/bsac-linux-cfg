#!/usr/bin/env perl
# display some text in a 78 col wide banner line

use strict;
use English;

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
