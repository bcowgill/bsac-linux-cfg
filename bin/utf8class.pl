#!/usr/bin/env perl
# utf8class.pl
# output a list of utf8 characters which possess the unicode class provided

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:loose); # :loose if you perl version supports it
use Unicode::UCD qw( charinfo general_categories );
binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

my $MAX_CODEPOINT = hex('10FFFF');
my $OB = '\{';
my $CB = '\}';

my @Interesting = qw(
	arrows
	ascii
	ascii_hex_digit
	blank
	block_elements
	box_drawing
	braille
	cased
	cased_letter
	case_ignorable
	close_punctuation
	control
	control_pictures
	currency_symbol
	currency_symbols
	dash
	dash_punctuation
	decimal_number
	diacritic
	digit
	dingbats
	domino
	domino_tiles

	letter
	number
	upper
	lower
	open_punctuation
);

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	print << "USAGE";
Usage:
$0 [-N] [-all] \\p{Letter}

Output a table of utf8 characters matching the unicode properties specified.

-N	specify how many characters to show. default is 26
-all show all matching characters. (will take a long time)

See this url for perl's supported \\p{...} unicode properties

http://perldoc.perl.org/perluniprops.html

example:

$0 -10 \\p{Letter}

$0 script=Latin

$0 Numeric_Value=5

$0 Line_Break=Hyphen

USAGE
	exit(0);
}

my $count = 26;
my @Property = ();

if (scalar(@ARGV)) {

	map {
		output($ARG);
	} @ARGV;
	printTable(charnames::string_vianame('U+0000'));
}

sub output
{
	my ($line) = @ARG;

	# -N, --all updates count value
	$line =~ s{\A \s*
		--?(\d+|all)
		 \s* \z}{$count = ($1 eq 'all') ? $MAX_CODEPOINT : $1; ''}xmse;

	$line =~ s{\A \s*
			\\* ([pP])(.+)
		\s* \z}{push(@Property, qq{\\$1$2}); ''}xmse;

	$line =~ s{\A \s*
			$OB? (.+?) $CB?
		\s* \z}{push(@Property, qq{\\p{$1}}); ''}xmse;
}

sub printTable
{
	my ($char) = @ARG;

	for (my $remain = $count; $remain; --$remain, $char = nextChar($char))
	{
		++$remain;
		my $hex = charToCodePt($char);
		my $name = charnames::viacode(ord($char)) || "";

		if ($name)
		{
			$name = toCategory($char) . "\t" . $name;
			if (checkProperties($char)) {
				--$remain;
				print qq{$char\t$hex\t$name\n}
			}
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

sub checkProperties
{
	my ($char) = @ARG;
	my $matched = 1;
	foreach my $property (@Property) {
		unless ($char =~ m{$property}) {
			$matched = 0;
			last;
		}
	}
	return $matched;
}
