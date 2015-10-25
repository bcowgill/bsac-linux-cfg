#!/usr/bin/env perl
# utf8.pl
# output utf8 given U+XXXX code points or \N{...} code point or character name
# processes arguments or stdin

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full);
binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	print << "USAGE";
Usage:
$0 U+XXXX {U+XXXX} \\\\N{UNICODE_CHARACTER_NAME}

Output unicode utf8 characters given a mixture of text and code points or character names.
If no arguments given it will read from STDIN. Otherwise it will parse the arguments and output utf8 from them.

example:

$0 U+0100 \\\\N{WHITE_SMILING_FACE}
USAGE
	exit(0);
}

if (scalar(@ARGV)) {
	print map {
		toUTF8($ARG);
	} @ARGV;
}
else
{
	while (my $line = <>)
	{
		$line =~ s{
			\{ (U \+ [0-9a-f]+) \}
		}{ toUTF8($1); }xmsgei;
		$line =~ s{
			\b (U \+ [0-9a-f]+) \b
		}{ toUTF8($1); }xmsgei;
		$line =~ s{
			( \\N \{ ([^\}]+) \} )
		}{ toUTF8($1); }xmsgei;
		print $line;
	}
}

sub toUTF8 {
	my ($string) = @ARG;
	my $ret = $string;
	if ($string =~ m{ \A U \+ [0-9a-f]+ \z }xmsi)
	{
		$ret = charnames::string_vianame(uc($string));
	}
	elsif ($string =~ m{ \A \\N \{ ([^\}]+) \} \z }xmsi)
	{
		my $name = uc($1);
		$name =~ s{[_-]}{ }xmsg;
		$ret = charnames::string_vianame($name);
	}
	return $ret;
}