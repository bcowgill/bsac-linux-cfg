#!/usr/bin/env perl
use utf8;	  # so literals and identifiers can be in UTF-8
#use v5.12;	 # or later to get "unicode_strings" feature
use v5.16;	 # later version so we can use case folding fc() function directly
use strict;	# quote strings, declare variables
use warnings;  # on by default
use warnings  qw(FATAL utf8);	# fatalize encoding glitches
use open	  qw(:std :utf8);	# undeclared streams in UTF-8
#use charnames qw(:full :short);  # unneeded in v5.16
use Unicode::UCD qw( charinfo general_categories );  # to get category of character
use Unicode::Normalize qw(check); # to check normalisation
use Encode qw(decode_utf8); # to convert args/env vars

use feature "fc"; # fc() function is from v5.16
# OR
#use Unicode::CaseFold;

use English qw(-no_match_vars);

my $block = "\N{U+2588}";

my @map = ('const spaceMap = {');
my $regex = 'const reSpaces = /[\\s';

sub show_spacing
{
	my ($name, $code, $space) = @_;
	$code =~ m{U\+(.+?)\t}xms;
	my $utf = $1;
	print qq{Spacing with $code\nconst $name = '\\u$utf';\n$block$space$block\n$space$block\n};
	$name = uc($name);
	push(@map, qq{\t'\\u$utf': '[$name]',});
	$regex .= qq{\\u$utf};
}

show_spacing("space", "U+20	[SpaceSeparator]	SPACE", " ");
show_spacing("nbsp", "U+A0	[SpaceSeparator]	NO-BREAK SPACE", "\N{U+A0}");
show_spacing("narrowNbsp", "U+202F	[SpaceSeparator]	NARROW NO-BREAK SPACE", "\N{U+202F}");
show_spacing("zeroNbsp", "U+FEFF	[Format]	ZERO WIDTH NO-BREAK SPACE", "\N{U+FEFF}");
show_spacing("enquad", "U+2000	[SpaceSeparator]	EN QUAD", "\N{U+2000}");
show_spacing("emquad", "U+2001	[SpaceSeparator]	EM QUAD", "\N{U+2001}");
show_spacing("enspace", "U+2002	[SpaceSeparator]	EN SPACE", "\N{U+2002}");
show_spacing("emspace", "U+2003	[SpaceSeparator]	EM SPACE", "\N{U+2003}");
show_spacing("threePerEmSpace", "U+2004	[SpaceSeparator]	THREE-PER-EM SPACE", "\N{U+2004}");
show_spacing("fourPerEmSpace", "U+2005	[SpaceSeparator]	FOUR-PER-EM SPACE", "\N{U+2005}");
show_spacing("sixPerEmSpace", "U+2006	[SpaceSeparator]	SIX-PER-EM SPACE", "\N{U+2006}");
show_spacing("figureSpace", "U+2007	[SpaceSeparator]	FIGURE SPACE", "\N{U+2007}");
show_spacing("punctSpace", "U+2008	[SpaceSeparator]	PUNCTUATION SPACE", "\N{U+2008}");
show_spacing("thinSpace", "U+2009	[SpaceSeparator]	THIN SPACE", "\N{U+2009}");
show_spacing("hairSpace", "U+200A	[SpaceSeparator]	HAIR SPACE", "\N{U+200A}");
show_spacing("zeroSpace", "U+200B	[Format]	ZERO WIDTH SPACE", "\N{U+200B}");
show_spacing("medMathSpace", "U+205F	[SpaceSeparator]	MEDIUM MATHEMATICAL SPACE", "\N{U+205F}");
show_spacing("ideoGraphicSpace", "U+3000	[SpaceSeparator]	IDEOGRAPHIC SPACE", "\N{U+3000}");
show_spacing("ideoGraphicHalfFillSpace", "U+303F	[OtherSymbol]	IDEOGRAPHIC HALF FILL SPACE", "\N{U+303F}");
show_spacing("tagSpace", "U+E0020	[Format]	TAG SPACE", "\N{U+E0020}");
show_spacing("softHyphen", "U+AD	[Format]	SOFT HYPHEN", "\N{U+AD}");
show_spacing("hyphen", "U+2010	[DashPunctuation]	HYPHEN", "\N{U+2010}");
show_spacing("nbHyphen", "U+2011	[DashPunctuation]	NON-BREAKING HYPHEN", "\N{U+2011}");
show_spacing("hyphenPoint", "U+2027	[OtherPunctuation]	HYPHENATION POINT", "\N{U+2027}");
show_spacing("smallHyphen", "U+FE63	[DashPunctuation]	SMALL HYPHEN-MINUS", "\N{U+FE63}");
show_spacing("fullWidthHyphen", "U+FF0D	[DashPunctuation]	FULLWIDTH HYPHEN-MINUS", "\N{U+FF0D}");
show_spacing("tagHyphen", "U+E002D	[Format]	TAG HYPHEN-MINUS", "\N{U+E002D}");

push(@map, "}; // spaceMap\n");
$regex .= ']';

print join("\n", @map);
print qq{$regex/;\n};
__END__
show_spacing("", "
	", "\N{U+}");

-	U+2D	[DashPunctuation]	HYPHEN-MINUS
֊	U+58A	[DashPunctuation]	ARMENIAN HYPHEN
᐀	U+1400	[DashPunctuation]	CANADIAN SYLLABICS HYPHEN
᠆	U+1806	[DashPunctuation]	MONGOLIAN TODO SOFT HYPHEN
⁃	U+2043	[OtherPunctuation]	HYPHEN BULLET
⸗	U+2E17	[DashPunctuation]	DOUBLE OBLIQUE HYPHEN
⸚	U+2E1A	[DashPunctuation]	HYPHEN WITH DIAERESIS
゠	U+30A0	[DashPunctuation]	KATAKANA-HIRAGANA DOUBLE HYPHEN

፡	U+1361	[OtherPunctuation]	ETHIOPIC WORDSPACE
 	U+1680	[SpaceSeparator]	OGHAM SPACE MARK
␈	U+2408	[OtherSymbol]	SYMBOL FOR BACKSPACE
␠	U+2420	[OtherSymbol]	SYMBOL FOR SPACE

	U+17	[Control]	END OF TRANSMISSION BLOCK
␗	U+2417	[OtherSymbol]	SYMBOL FOR END OF TRANSMISSION BLOCK
▀	U+2580	[OtherSymbol]	UPPER HALF BLOCK
▁	U+2581	[OtherSymbol]	LOWER ONE EIGHTH BLOCK
▂	U+2582	[OtherSymbol]	LOWER ONE QUARTER BLOCK
▃	U+2583	[OtherSymbol]	LOWER THREE EIGHTHS BLOCK
▄	U+2584	[OtherSymbol]	LOWER HALF BLOCK
▅	U+2585	[OtherSymbol]	LOWER FIVE EIGHTHS BLOCK
▆	U+2586	[OtherSymbol]	LOWER THREE QUARTERS BLOCK
▇	U+2587	[OtherSymbol]	LOWER SEVEN EIGHTHS BLOCK
█	U+2588	[OtherSymbol]	FULL BLOCK
▉	U+2589	[OtherSymbol]	LEFT SEVEN EIGHTHS BLOCK
▊	U+258A	[OtherSymbol]	LEFT THREE QUARTERS BLOCK
▋	U+258B	[OtherSymbol]	LEFT FIVE EIGHTHS BLOCK
▌	U+258C	[OtherSymbol]	LEFT HALF BLOCK
▍	U+258D	[OtherSymbol]	LEFT THREE EIGHTHS BLOCK
▎	U+258E	[OtherSymbol]	LEFT ONE QUARTER BLOCK
▏	U+258F	[OtherSymbol]	LEFT ONE EIGHTH BLOCK
▐	U+2590	[OtherSymbol]	RIGHT HALF BLOCK
▔	U+2594	[OtherSymbol]	UPPER ONE EIGHTH BLOCK
▕	U+2595	[OtherSymbol]	RIGHT ONE EIGHTH BLOCK
