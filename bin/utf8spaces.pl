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

sub show_spacing
{
	my ($code, $space) = @_;
	print qq{Spacing with $code\n$block$space$block\n$space$block\n};
}

show_spacing("U+20	[SpaceSeparator]	SPACE", " ");
show_spacing("U+A0	[SpaceSeparator]	NO-BREAK SPACE", "\N{U+A0}");
show_spacing("U+2000	[SpaceSeparator]	EN QUAD", "\N{U+2000}");
__END__
show_spacing(
	, "\N{U+}");
፡	U+1361	[OtherPunctuation]	ETHIOPIC WORDSPACE
 	U+1680	[SpaceSeparator]	OGHAM SPACE MARK
 	U+2001	[SpaceSeparator]	EM QUAD
 	U+2002	[SpaceSeparator]	EN SPACE
 	U+2003	[SpaceSeparator]	EM SPACE
 	U+2004	[SpaceSeparator]	THREE-PER-EM SPACE
 	U+2005	[SpaceSeparator]	FOUR-PER-EM SPACE
 	U+2006	[SpaceSeparator]	SIX-PER-EM SPACE
 	U+2007	[SpaceSeparator]	FIGURE SPACE
 	U+2008	[SpaceSeparator]	PUNCTUATION SPACE
 	U+2009	[SpaceSeparator]	THIN SPACE
 	U+200A	[SpaceSeparator]	HAIR SPACE
​	U+200B	[Format]	ZERO WIDTH SPACE
 	U+202F	[SpaceSeparator]	NARROW NO-BREAK SPACE
 	U+205F	[SpaceSeparator]	MEDIUM MATHEMATICAL SPACE
␈	U+2408	[OtherSymbol]	SYMBOL FOR BACKSPACE
␠	U+2420	[OtherSymbol]	SYMBOL FOR SPACE
　	U+3000	[SpaceSeparator]	IDEOGRAPHIC SPACE
〿	U+303F	[OtherSymbol]	IDEOGRAPHIC HALF FILL SPACE
﻿	U+FEFF	[Format]	ZERO WIDTH NO-BREAK SPACE
𝙰	U+1D670	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL A
𝙱	U+1D671	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL B
𝙲	U+1D672	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL C
𝙳	U+1D673	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL D
𝙴	U+1D674	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL E
𝙵	U+1D675	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL F
𝙶	U+1D676	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL G
𝙷	U+1D677	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL H
𝙸	U+1D678	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL I
𝙹	U+1D679	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL J
𝙺	U+1D67A	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL K
𝙻	U+1D67B	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL L
𝙼	U+1D67C	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL M
𝙽	U+1D67D	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL N
𝙾	U+1D67E	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL O
𝙿	U+1D67F	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL P
𝚀	U+1D680	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL Q
𝚁	U+1D681	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL R
𝚂	U+1D682	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL S
𝚃	U+1D683	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL T
𝚄	U+1D684	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL U
𝚅	U+1D685	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL V
𝚆	U+1D686	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL W
𝚇	U+1D687	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL X
𝚈	U+1D688	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL Y
𝚉	U+1D689	[UppercaseLetter]	MATHEMATICAL MONOSPACE CAPITAL Z
𝚊	U+1D68A	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL A
𝚋	U+1D68B	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL B
𝚌	U+1D68C	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL C
𝚍	U+1D68D	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL D
𝚎	U+1D68E	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL E
𝚏	U+1D68F	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL F
𝚐	U+1D690	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL G
𝚑	U+1D691	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL H
𝚒	U+1D692	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL I
𝚓	U+1D693	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL J
𝚔	U+1D694	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL K
𝚕	U+1D695	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL L
𝚖	U+1D696	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL M
𝚗	U+1D697	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL N
𝚘	U+1D698	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL O
𝚙	U+1D699	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL P
𝚚	U+1D69A	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL Q
𝚛	U+1D69B	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL R
𝚜	U+1D69C	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL S
𝚝	U+1D69D	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL T
𝚞	U+1D69E	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL U
𝚟	U+1D69F	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL V
𝚠	U+1D6A0	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL W
𝚡	U+1D6A1	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL X
𝚢	U+1D6A2	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL Y
𝚣	U+1D6A3	[LowercaseLetter]	MATHEMATICAL MONOSPACE SMALL Z
𝟶	U+1D7F6	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT ZERO
𝟷	U+1D7F7	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT ONE
𝟸	U+1D7F8	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT TWO
𝟹	U+1D7F9	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT THREE
𝟺	U+1D7FA	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT FOUR
𝟻	U+1D7FB	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT FIVE
𝟼	U+1D7FC	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT SIX
𝟽	U+1D7FD	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT SEVEN
𝟾	U+1D7FE	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT EIGHT
𝟿	U+1D7FF	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT NINE
󠀠	U+E0020	[Format]	TAG SPACE

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
