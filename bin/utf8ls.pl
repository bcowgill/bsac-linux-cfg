#!/usr/bin/env perl
# utf8ls.pl
# output a list of utf8 characters given U+XXXX code points or \N{...} code point or character name
# processes arguments or stdin

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:loose); # :loose if you perl version supports it
use Unicode::UCD qw( charinfo general_categories );
use FindBin;

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

my $MAX_CODEPOINT = hex('10FFFF');

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	my $cmd = $FindBin::Script;

	print << "USAGE";
usage: $cmd [-N] [-all] U+XXXX {U+XXXX} "\\\\N{UNICODE_CHARACTER_NAME}" '\\N{UNICODE_CHARACTER_NAME}'

Output a table of utf8 characters starting at a given code point.

-N   specify how many characters to show. default is 26
-all show all remaining characters from the starting code point

example:

$cmd -10 U+0100 \\\\N{WHITE_SMILING_FACE}
USAGE
	exit(0);
}

my $count = 26;

if (scalar(@ARGV)) {

	map {
		output($ARG);
	} @ARGV;
}

sub output
{
	my ($line) = @ARG;

	# -N updates count value
	$line =~ s{\A \s* --?(\d+|all) \s* \z}{$count = ($1 eq 'all') ? $MAX_CODEPOINT : $1}xmse;

	$line =~ s{
		\A \s*
		\{ (U \+ [0-9a-f]+) \}
		\s* \z
	}{ toUTF8($1); }xmsgei;
	$line =~ s{
		\A \s*
		(U \+ [0-9a-f]+)
		\s* \z
	}{ toUTF8($1); }xmsgei;
	$line =~ s{
		\A \s*
		( \\N \{ ([^\}]+) \} )
		\s* \z
	}{ toUTF8($1); }xmsgei;
}

sub toUTF8
{
	my ($string) = @ARG;
	my $ret = $string;
	if ($string =~ m{ \A U \+ [0-9a-f]+ \z }xmsi)
	{
		$ret = charnames::string_vianame(uc($string));
	}
	elsif ($string =~ m{ \A \\N \{ ([^\}]+) \} \z }xmsi)
	{
		my $name = uc($1);
		my $loose_name = $name;
		$loose_name =~ s{[_\s-]}{_}xmsg;
		$ret = charnames::string_vianame($name)
			|| charnames::string_vianame($loose_name)
			|| die "Unknown character \\N{$name}";
	}
	printTable($ret);
}

sub printTable
{
	my ($char) = @ARG;

	for (my $remain = $count; $remain; --$remain, $char = nextChar($char))
	{
		my $hex = charToCodePt($char);
		my $name = charnames::viacode(ord($char)) || "";

		if ($name)
		{
			$name = toCategory($char) . "\t" . $name;
			print qq{$char\t$hex\t$name\n};
		}
		last if ord($char) == $MAX_CODEPOINT;
	}
}

sub nextChar
{
	my ($char) = @ARG;
	return chr(ord($char) + 1);
}

sub charToCodePt
{
	my ($char) = @ARG;
	return sprintf("U+%X", ord($char));
}

sub toCategory
{
	my ($char) = @ARG;

	my $fullCategory = "[category unknown]";

	eval
	{
		# To translate this category into something more human friendly:

		#use Unicode::UCD qw( charinfo general_categories );
		my $rhCategories = general_categories();
		my $category = charinfo(charToCodePt($char))->{category};  # "Lu"
		$fullCategory = "[$category]";
		$fullCategory = "[$rhCategories->{ $category }]"; # "UppercaseLetter"
	};
	if ($EVAL_ERROR)
	{
		print "ERROR: $EVAL_ERROR";
	}
	return $fullCategory;
}
