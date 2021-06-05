#!/usr/bin/env perl
# TODO markers below for a few remaining special cases
# ./open-close-punctuation.sh > samples/open-close-unicode-punctuation.txt
# ./open-close-punctuation.sh | ./quote-samples.pl > samples/open-close-quote-punctuation.txt

use strict;
use warnings;
use English qw(-no_match_vars);
use Data::Dumper;
use Carp;

my $DEBUG = 0;

my $CHAR_PAD = length("U+ABCD");
my $ODD = "  ODD\t";
my $ODD1 = "  ODD1\t";
my $ODD2 = "  ODD2\t";
my $ODD3 = "  ODD3\t";
my $ODD4 = "  ODD4\t";
my $ODD5 = "  ODD5\t";
my $ODD6 = "  ODD6\t";
my $NL = "\n\n";

if (!$DEBUG)
{
	$ODD1 = $ODD2 = $ODD3 = $ODD4 = $ODD5 = $ODD6 = $ODD;
}

my $previous;
my $current;

my $buffered = 0;
my $buffer = '';
my $vertical_top = '';
my $vertical_inner = '';
my $vertical_bottom = '';
my @vertical_solitary = ();

my %holding_area = ();
my @oddballs = qw(
	201E 201C
	201A 2018
	301F 301D
);
my @inners = qw(
   23B6 23B4
   23B4 23B5
	23B5 23B5
);
my %oddballs = map { "U+$ARG" } @oddballs;
my %inners = map { "U+$ARG" } @inners;
my $reOddballs = join('|', @oddballs);
my $reInners = join('|', @inners);

sub pad
{
	my ($value, $size) = @ARG;
	croak "FAIL" unless $value;
	return $value . (' ' x (($size||$CHAR_PAD) - length($value)));
}

sub codes
{
	my ($begin, $end, $inner) = @ARG;
	if ($inner) {
		return pad($begin, $CHAR_PAD + 1) . pad($inner, $CHAR_PAD + 1) . pad($end);
	}
	return pad($begin, $CHAR_PAD + 1) . pad($end);
}

sub name
{
	my ($begin, $end) = @ARG;
	my $basic = $begin;
	if ($begin eq $end)
	{
		return $begin;
	}
	elsif ($begin =~ m{TOP|LEFT|GYON|REVERSED}xms && $end =~ m{BOTTOM|RIGHT|GYAS|LOW}xms)
	{
		$begin =~ s{(REVERSED)}{$1/LOW}xms;
		$begin =~ s{(TOP)}{$1/BOTTOM}xms;
		$begin =~ s{(LEFT)}{$1/RIGHT}xms;
		$begin =~ s{(GYON)}{$1/GYAS}xms;
		return $begin;
	}
	elsif ($end =~ m{TOP|LEFT|GYON}xms && $begin =~ m{BOTTOM|RIGHT|GYAS}xms)
	{
		$end =~ s{(TOP)}{$1/BOTTOM}xms;
		$end =~ s{(LEFT)}{$1/RIGHT}xms;
		$end =~ s{(GYON)}{$1/GYAS}xms;
		return $end;
	}
	elsif ($begin =~ m{REVERSED|TURNED}xms)
	{
		$basic =~ s{(REVERSED|TURNED)\s+}{}xms;
		if ($basic eq $end)
		{
			$begin =~ s{(REVERSED|TURNED)}{[$1/]}xms;
			return qq{$begin};
		}
	}
	elsif ($end =~ m{REVERSED|TURNED}xms)
	{
		$basic = $end;
		$basic =~ s{(REVERSED|TURNED)\s+}{}xms;
		if ($basic eq $begin)
		{
			$end =~ s{(REVERSED|TURNED)}{[/$1]}xms;
			return qq{$end};
		}
	}
	return qq{$begin / $end};
}

sub quote
{
	my ($begin, $end, $text) = @ARG;
	$text = $text || '';
	return qq{$begin$text$end};
}

sub class
{
	my ($begin, $end, $inner) = @ARG;
	if ($inner)
	{
		return ($begin eq $inner && $inner eq $end) ? $begin : (class($begin, $inner) . ' ' . $end);
	}
	return $begin eq $end ? $begin : qq{$begin $end};
}

sub quotation_begin_end
{
	my ($previous, $current, $where) = @ARG;

	# TODO VERTICALs that aren't -- is it an error in the unicode character or labelling?
	# ⸠⸡	U+2E20 U+2E21
	# ﹇﹈	U+FE47 U+FE48
	return vertical_begin_end($previous, $current, $where) if $previous->{vertical};

	my $codes = codes($previous->{code}, $current->{code});
	my $class = class($previous->{class}, $current->{class});
	my $name = name($previous->{name}, $current->{name});
	my $quotes = quote($previous->{char}, $current->{char});
	my $spaced = quote($previous->{char}, $current->{char}, '   ');
	my $example = quote($previous->{char}, $current->{char}, qq{$codes $name $class});
	say(qq{\t$quotes\t$spaced\t$example$NL});
}

sub say
{
	my ($line) = @ARG;
	if ($buffered)
	{
		$buffer .= $line;
	}
	else
	{
		print qq{$line};
	}
}

# ⎴
# i
# ⎶
# j
# ⎵	⎴⎶⎵	U+23B4 U+23B6 U+23B5 TOP/BOTTOM SQUARE BRACKET / BOTTOM SQUARE BRACKET OVER TOP SQUARE BRACKET [VERTICAL] [OtherSymbol]

sub vertical_begin_inner_end
{
	my ($previous, $current, $inner) = @ARG;
	my $codes = codes($previous->{code}, $current->{code}, $inner->{code});
	my $class = class($previous->{class}, $current->{class}, $inner->{class});
	my $name = name($previous->{name}, $current->{name}) . ' / ' . $inner->{name};
	my $quotes = quote($previous->{char}, $current->{char}, $inner->{char});
	my $letter = "ｉ"; # full width unicode letter i
	if ($previous->{code} =~ m{U\+(23B4|23B5)}xms)
	{
		$letter = 'i';
	}
	my $solitary = quote($previous->{char}, $current->{char}, "\n$letter\n$inner->{char}\n$letter\n");
	#my $solitary = quote($previous->{char}, $current->{char}, "\nᴟ\n");
	my $example = qq{$codes $name $class};
	say(qq{$solitary\t$quotes\t$example$NL});

	$vertical_top = "$previous->{char} $vertical_top";
	$vertical_inner = "$inner->{char} $vertical_inner";
	$vertical_bottom = "$current->{char} $vertical_bottom";
	push(@vertical_solitary, $solitary);
}

# ︽
# ｉ
# ︾	︽︾	U+FE3D U+FE3E PRESENTATION FORM FOR VERTICAL LEFT/RIGHT DOUBLE ANGLE BRACKET [OpenPunctuation] [ClosePunctuation]

sub vertical_begin_end
{
	my ($previous, $current) = @ARG;
	my $codes = codes($previous->{code}, $current->{code});
	my $class = class($previous->{class}, $current->{class});
	my $name = name($previous->{name}, $current->{name});
	my $quotes = quote($previous->{char}, $current->{char});
	my $letter = "ｉ"; # full width unicode letter i
	if ($previous->{code} =~ m{U\+(23B4|23B5)}xms)
	{
		$letter = 'i';
	}
	my $solitary = quote($previous->{char}, $current->{char}, "\n$letter\n");
	#my $solitary = quote($previous->{char}, $current->{char}, "\nᴟ\n");
	my $example = qq{$codes $name $class};
	say(qq{$solitary\t$quotes\t$example$NL});

	$vertical_top .= "$previous->{char} ";
	$vertical_inner .= "  ";
	$vertical_bottom .= "$current->{char} ";
	push(@vertical_solitary, $solitary);
}

sub flush
{
	$vertical_top =~ s{\s\z}{}xms;
	$vertical_inner =~ s{\s\z}{}xms;
	$vertical_bottom =~ s{\s\z}{}xms;
	print qq{$vertical_top\n$vertical_inner\n$vertical_bottom$NL$buffer};
}

while (my $line = <>)
{
	chomp($line);
	if ($current)
	{
		$previous = $current;
	}

	if ($line =~ m{\A[.A-Z]})
	{
		$current = { type => "heading", line => $line }
	}
	elsif ($line =~ m{\A\s*\z}xms)
	{
		$current = { type => "blank", line => $line }
	}
	elsif ($line =~ m{\t}xms)
	{
		my ($char, $code, $class, $name) = split(/\t/, $line);
		my $symbol = $class =~ m{OtherSymbol}xms;
		my $begin = $class =~ m{Open|Initial}xms;
		my $end = $class =~ m{Close|Final}xms;
		my $open = $class =~ m{Open}xms;
		my $close = $class =~ m{Close}xms;
		my $initial = $class =~ m{Initial}xms;
		my $final = $class =~ m{Final}xms;
		my $inner = $symbol && $name =~ m{BOTTOM.+TOP}xms;
		my $vertical = $inner || $name =~ m{VERTICAL}xms;
		if ($symbol)
		{
			if (!$inner && $name =~ m{COMMA\s+QUOTATION|TOP|BOTTOM}xms && $name !~ m{LOW}xms)
			{
				if ($name =~ m{TURNED}xms)
				{
					$begin = $initial = 1;
				}
				elsif ($name =~ m{TOP}xms)
				{
					$begin = $open = 1;
				}
				elsif ($name =~ m{BOTTOM}xms)
				{
					$end = $close = 1;
				}
				else
				{
					$end = $final = 1;
				}
			}
			elsif ($name =~ m{LOW}xms)
			{
				$begin = $end = $open = $close = 1;
			}
		}
		$current = {
			type => "character",
			char => $char,
			code => $code,
			class => $class,
			symbol => $symbol,
			vertical => $vertical,
			begin => $begin,
			end => $end,
			initial => $initial,
			final => $final,
			open => $open,
			inner => $inner,
			close => $close,
			name => $name,
			line => $line,
		};
		if ($code =~ m{U\+($reOddballs|$reInners)}xms)
		{
			# hold onto German low/high quotation marks and Open/Inner/Close bracktes...
			$holding_area{$code} = $current;
			print Dumper($current) if $DEBUG;
		}

		if ($DEBUG && $symbol)
		{
			print Dumper($current);
		}
	}
	else
	{
		$current = { type => "unknown", line => $line }
	}

	print Dumper($current) if $DEBUG;
	if ($previous)
	{
		# Open/Close can only be used as Open...Close
		# Initial/Final can be used Initial...Final or Final...Initial

		if ($previous->{begin} && $current->{end})
		{
			quotation_begin_end($previous, $current, 'normal ' . $previous->{code});
			quotation_begin_end($current, $previous, 'reversed ' . $previous->{code}) if $previous->{initial};
			undef $previous;
			undef $current;
		}
		#elsif ($previous->{open} && $current->{initial})
		#{
		#	quotation_begin_end($previous, $current);
		#	#quotation_begin_end($current, $previous) if $previous->{initial};
		#	undef $previous;
		#	undef $current;
		#}
	}

	if ($current && $current->{type} =~ m{heading|blank}xms)
	{
		say(qq{$ODD1$previous->{line}$NL}) if $previous;
		say(qq{$line$NL});
		$buffered = 1 if $line =~ m{VERTICAL};
		undef $previous;
		undef $current;
	}
	elsif ($current && $oddballs{$current->{code}})
	{
		# Handle german low/high quotation marks...
		say(qq{$ODD2$previous->{line}$NL}) if $previous;
		if ($current->{close})
		{
			quotation_begin_end($holding_area{$oddballs{$current->{code}}}, $current, 'oddball close' . $current->{code});
		}
		else
		{
			quotation_begin_end($current, $holding_area{$oddballs{$current->{code}}}, 'oddball ' . $current->{code});
		}
		undef $previous;
		undef $current;
	}
	elsif ($current && $inners{$current->{code}})
	{
		# Handle open/inner/close brackets
		say(qq{$ODD3$previous->{line}$NL}) if $previous && !$inners{$previous->{code}};
		my $target = $inners{$current->{code}};
		if ($target ne $current->{code} && $holding_area{$target})
		{
			my $inner = $holding_area{$current->{code}};
			my $open = $holding_area{$target};
			my $close = $holding_area{$inners{$open->{code}}};
			vertical_begin_inner_end($open, $close, $inner);
		}
		undef $previous;
		undef $current;
	}
	elsif ($current && $current->{begin} && $current->{end})
	{
		say(qq{$ODD4$previous->{line}$NL}) if $previous;
		quotation_begin_end($current, $current, 'non-sided ' . $current->{code});
		undef $previous;
		undef $current;
	}
	elsif ($current && $current->{type} ne 'unknown')
	{
		say(qq{$ODD5$previous->{line}$NL}) if $previous;
	}
	elsif ($current)
	{
		say(qq{$ODD6$previous->{line}$NL}) if $previous;
		say(qq{UNKNOWN: $line$NL});
		undef $previous;
		undef $current;
	}

}

flush();

print qq{Created by: ./open-close-punctuation.sh | ./quote-samples.pl\n};

__END__
sample input to parse from open-close-punctuation.sh:

QUOTATION
‘	U+2018	[InitialPunctuation]	LEFT SINGLE QUOTATION MARK
’	U+2019	[FinalPunctuation]	RIGHT SINGLE QUOTATION MARK
‚	U+201A	[OpenPunctuation]	SINGLE LOW-9 QUOTATION MARK
‛	U+201B	[InitialPunctuation]	SINGLE HIGH-REVERSED-9 QUOTATION MARK
...DOUBLE
“	U+201C	[InitialPunctuation]	LEFT DOUBLE QUOTATION MARK

https://renenyffenegger.ch/notes/development/Unicode/index
Open Punctuation
Close Punctuation
Initial Punctuation (Behaves either as Open Punctuation or Close Punctuation, depending on usage)
Final Punctuation (Behaves either as Open Punctuation or Close Punctuation, depending on usage)

https://stackoverflow.com/questions/62195115/why-is-unicode-character-double-low-9-quotation-mark-u201e-not-a-quotation

The general categories Pi (Initial_Punctuation) and Pf (Final_Punctuation) are not used exclusively for quotation marks, just like Ps (Open_Punctuation) and Pe (Close_Punctuation) are not used exclusively for characters that aren’t quotation marks. Rather, Pi and Pf are used for pairs of characters where either one can be opening or closing depending on usage, whereas Ps characters are always opening and Pe characters are always closing (ignoring rare or specialised cases). Which of these general categories a character belongs to is based on these considerations and has nothing to do with whether it is a quotation mark, a bracket or something else.

https://german.stackexchange.com/questions/117/what-is-the-correct-way-to-denote-a-quotation-in-german

There are three legal variants:

„Gänsefüßchen“ and for quotations in quotations ‚ ‘.  U+201E U+201C   U+201A U+2018
»Guillemets« and › ‹
Reversed «Guillemets» and ‹ ›. There is usually a thin space between the word and the quotation mark.
The first version is the most used in Germany, followed by the second.
The third is the preferred in Switzerland but allowed in a German text too.

Explanation of Unicode character classes:
https://docs.microsoft.com/en-us/dotnet/api/system.globalization.unicodecategory?view=net-5.0

OpenPunctuation	20
Opening character of one of the paired punctuation marks, such as parentheses, square brackets, and braces. Signified by the Unicode designation "Ps" (punctuation, open). The value is 20.

ClosePunctuation	21
Closing character of one of the paired punctuation marks, such as parentheses, square brackets, and braces. Signified by the Unicode designation "Pe" (punctuation, close). The value is 21.

InitialQuotePunctuation	22
Opening or initial quotation mark character. Signified by the Unicode designation "Pi" (punctuation, initial quote). The value is 22.

FinalQuotePunctuation	23
Closing or final quotation mark character. Signified by the Unicode designation "Pf" (punctuation, final quote). The value is 23.

ConnectorPunctuation	18
Connector punctuation character that connects two characters. Signified by the Unicode designation "Pc" (punctuation, connector). The value is 18.

DashPunctuation	19
Dash or hyphen character. Signified by the Unicode designation "Pd" (punctuation, dash). The value is 19.

OtherPunctuation	24
Punctuation character that is not a connector, a dash, open punctuation, close punctuation, an initial quote, or a final quote. Signified by the Unicode designation "Po" (punctuation, other). The value is 24.

Format	15
Format character that affects the layout of text or the operation of text processes, but is not normally rendered. Signified by the Unicode designation "Cf" (other, format). The value is 15.

NonSpacingMark	5
Nonspacing character that indicates modifications of a base character. Signified by the Unicode designation "Mn" (mark, nonspacing). The value is 5.


	︽︾	︽ ︾	︽U+FE3D U+FE3E PRESENTATION FORM FOR VERTICAL LEFT/RIGHT DOUBLE ANGLE BRACKET [OpenPunctuation] [ClosePunctuation]︾

	︽︾ U+FE3D U+FE3E PRESENTATION FORM FOR VERTICAL LEFT/RIGHT DOUBLE ANGLE BRACKET [OpenPunctuation] [ClosePunctuation]
	︽
	ᴟ
	︾
What is proper usage of these? -- found a unicode site which explains how they should be used.

U+201A U+201B ‚left-right single low-high quotes‛ [OpenPunctuation] [InitialPunctuation] SINGLE LOW-9 QUOTATION MARK / SINGLE HIGH-REVERSED-9 QUOTATION MARK

U+201B https://www.fileformat.info/info/unicode/char/2018/index.htm
-- U+2018 is preferred as left single quote instead of U+201B
-- looks same as U+02BD but that is a different function.
should not be used as a quotation mark

-- U+201C is preferred as left double quote instead of U+201F
-- looks same as U+201C
should not be used as a quotation mark

U+201E U+201F „left-right double low-high quotes‟ [OpenPunctuation] [InitialPunctuation] DOUBLE LOW-9 QUOTATION MARK / DOUBLE HIGH-REVERSED-9 QUOTATION MARK

U+301D U+301F 〝left-right full-width high-low double prime quotes〟[OpenPunctuation] [ClosePunctuation] REVERSED/LOW DOUBLE PRIME QUOTATION MARK

U+301F https://codepoints.net/U+301F
It is also used in the scripts Bopomofo, Hangul, Han, Hiragana, Katakana.

⍘	U+2358	[OtherSymbol]	APL FUNCTIONAL SYMBOL QUOTE UNDERBAR https://codepoints.net/U+2358
⍞	U+235E	[OtherSymbol]	APL FUNCTIONAL SYMBOL QUOTE QUAD https://codepoints.net/U+235E

The APL programming language is distinctive in being symbolic rather than lexical: its primitives are denoted by symbols, not words. These symbols were originally devised as a mathematical notation. APL programmers often assign informal names when discussing functions and operators (for example, product for ×/) but the core functions and operators provided by the language are denoted by non-textual symbols.

	U+E0022	[Format]	TAG QUOTATION MARK https://codepoints.net/U+E0022

TODO Additional incorrect.
˴       U+2F4   [ModifierSymbol]        MODIFIER LETTER MIDDLE GRAVE ACCENT

˵       U+2F5   [ModifierSymbol]        MODIFIER LETTER MIDDLE DOUBLE GRAVE ACCENT
˶       U+2F6   [ModifierSymbol]        MODIFIER LETTER MIDDLE DOUBLE ACUTE ACCENT

＇      U+FF07  [OtherPunctuation]      FULLWIDTH APOSTROPHE
｀      U+FF40  [ModifierSymbol]        FULLWIDTH GRAVE ACCENT

˝       U+2DD   [ModifierSymbol]        DOUBLE ACUTE ACCENT
⁗       U+2057  [OtherPunctuation]      QUADRUPLE PRIME
