#!/usr/bin/env perl
# WIP Work in progress
# An experiment in converting mathematical words and combinations into unicode character equivalents.

# Am keeping track of which utf8 characters have been used in:
# ~/bin/character-samples/samples/mathematics-categorised.txt

# cat tests/math-rep/in/math-rep.sample.txt | math-rep.pl | utf8.pl
# CATEG=~/bin/character-samples/samples/mathematics-categorised.txt
# MATH=~/bin/character-samples/samples/mathematics.txt
# vim $CATEG
# grep GREP $MATH
# utf8dbg.sh char
# grep-utf8.sh something >> $CATEG

# See math-rep.sample.txt for a full example file of syntax.
# See also unicode-alpha.sh
# ^x is a superscript x
# _x is a subscript x
# other words correspond to greek letters and operators
# echo PHI PSI del DELTA SIGMA gamma epsilon lamda mu pi rho dee epsilon phi int cross dot +- sum sqrt identical \<= \>= ^0 ^1 ^2 ^3 ^4 ^5 ^6 ^7 ^8 ^9 ^0 ^n _0 _1 _2 _3 _4 _5 _6 _7 _8 _9| math-rep.pl | utf8.pl

#TODO --fractions flag which converts 0.1 to 1/10 fraction
#TODO how to represent infinite repeating numbers 0.3... 0.{142857}...
#TODO replace mode which shows original line followed by replaced line double spaced.
#TODO replace mode which only shows the text to replace beside the replacement  @pi => @1 ℼ  => @pi ℼ  first replace the symbol with a numbered replacement @1 for example then when line is replaced change the @1 back to @pi for output
use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use charnames qw(:full); # :loose if you perl version supports it
use FindBin;
use Data::Dumper;

my $cmd_dir = $FindBin::Bin;

my $DEBUG = $ENV{DEBUG} || 0;

my $INDENT = ' ' x 4;
my $PAD_NAMES = 7;#16;
my $PAD_CHARS = 4;#16;
my $SEP = '|';
my $MAN = 0;
my $MARKUP = length($ENV{MARKUP}) ? $ENV{MARKUP} : 1; # replace markup codes with characters.
my $LITERAL = length($ENV{LITERAL}) ? $ENV{MARKUP} : 1; # replace literal values like 1/4 with their unicode character.
my $SHOW_CODE = $ENV{SHOW_CODE} || 0; # show unicode code point value instead of the character.
my $CUDDLE = $ENV{CUDDLE} || 0; # remove whitespace around symbols when they are replaced.
my $LEGEND = $ENV{LEGEND} || 0; # show literal/markup name along side the replaced value.

my $SAMPLE = "$cmd_dir/character-samples/samples/mathematics.txt";
my $CATEGORY = "$cmd_dir/character-samples/samples/mathematics-categorised.txt";

sub usage
{
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?] [--cuddle]  [--markup] [--literal] [--codes]

TODO Display a description of the program.
MARKUP=$MARKUP
LITERAL=$LITERAL
SHOW_CODE=$SHOW_CODE
CUDDLE=$CUDDLE
LEGEND=$LEGEND

--cuddle TODO...
--markup TODO...
--literal TODO...
--codes TODO ...
--legend TODO...
--help  shows help for this program.
--man   shows help for this program with full details.
-?      shows help for this program.

More detail ... TODO

There is a sample file categoriesed by replacement types:

$CATEGORY

@{[manpage()]}

See also ls-maths.sh utf8dbg.pl ... TODO

Example:

echo filename | $cmd

Format the supplied example markup document:

$cmd < $SAMPLE | less

USAGE
	exit 0;
}

sub manpage
{
	return <<"MANPAGE" if $MAN;
LITERAL REPLACEMENTS

- Fractions which have specific unicode characters:

    1/      ⅟   |    1/4     ¼   |    4/5     ⅘   |    3/8     ⅜
    1/2     ½   |    3/4     ¾   |    1/6     ⅙   |    5/8     ⅝
    0/3     ↉   |    1/5     ⅕   |    5/6     ⅚   |    7/8     ⅞
    1/3     ⅓   |    2/5     ⅖   |    1/7     ⅐   |    1/9     ⅑
    2/3     ⅔   |    3/5     ⅗   |    1/8     ⅛   |    1/10    ⅒

- Multi-character symbols with surrounding whitespace which can be replaced by specific unicode characters:

=/= == =/=/ ===

<= >= <== >== <=/=/ >=/=/ << >> </ >/ </=/ >/=/ <~ >~ </~/ >/~/ <> >< </>/ >/</ <. >. <<< >>> <=> >=< =< =>

~/ -~ ~= ~/=/ ~== ~=/ ~/=/=/ ~~ ~/~/ ~~= ~~~ ~===

Symbols are typed from left to right and represent the line strokes going from top to bottom.

i.e. ' <= ' is less than sign with equal sign below.

Normally a single whitespace is preserved around the symbol but you can use the CUDDLE option to remove it after replacement.

- Multi-character symbols which can be replaced by specific unicode characters:

+- ** // !!

MARKUP REPLACEMENTS

Multi-characters and additional markup which can be replaced by specific unicode characters:

- Subscripts on algebraic variables and constants:

X_0 X_1 X_2 X_3 X_4 X_5 X_6 X_7 X_8 X_9
X_a X_e X_h X_i X_j X_k X_l X_m X_n X_o X_p X_r X_s X_t X_u X_v X_x
X_beta X_gamma X_rho X_phi X_chi X_schwa
X_+ X_- X_= X_( X_) X_< X_> X_... X_<-
X_. X_*

X_2_3_._1_4
X_(_2_*_5_)
X_n_=_1_..._1_0
X_i_<_j
X_i_>_2
X_n_<-_m

Note: there are no unicode characters for these below, so they do nothing.

X_b X_c X_d X_f X_g X_q X_w X_y X_z
X_/ X_[ X_] X_->
X_A and all other capital letters
X_alpha and many other greek letters

- Superscripts or exponentiation on algebraic variables and constants:

X^0 X^1 X^2 X^3 X^4 X^5 X^6 X^7 X^8 X^9
X^G X^I X^N X^U
X^a X^b X^c X^d X^e X^f X^g X^h X^i X^j X^k X^l X^m X^n X^o X^p X^r X^s X^t X^u X^v X^w X^x X^y X^z
X^GAMMA X^PHI
X^alpha X^beta X^gamma X^delta X^theta X^iota X^upsilon X^phi X^chi X^schwa
X^+ X^- X^= X^( X^) X^< X^>
X^. X^*

Note: there are no unicode characters for these below, so they do nothing.

X^q
X^rho
X^... X^<-
X^A and many other capital letters
X^ALPHA and many other greek capital letters

You can also use _[...] or ^[...] bracketed text to indicate a full subscript or superscript expression:

X_[0.123456789*a + 4beta -3(gamma)]   Y^[0.123456789*a + 4beta -3(gamma)]

X₀․₁₂₃₄₅₆₇₈₉⸱ₐ ₊ ₄ᵦ ₋₃₍ᵧ₎           Y⁰⋅¹²³⁴⁵⁶⁷⁸⁹˙ᵃ ⁺ ⁴ᵝ ⁻³⁽ᵞ⁾

\@NAMED REPLACEMENTS

Using \@ as markup to indicate a named letter or symbol.  Add * for bold, / for italics and ! for double struck. Use \@name for lower case and \@NAME for upper case letters.

Normal Bold    Italic  Bold-Italic Double-Struck
\@name  \@*name  \@/name  \@*/name     \@!name

- Greek alphabet for mathematial symbols and values:

  Table sample of symbols to use with name for desired effects.

      Small               Capital                        |Bold
       (final)             (small)                       |  Italic
         [dbl]               [dbl]                       |    Bold+Italic
alpha  \@alpha              \@ALPHA                        |\@*alpha \@/alpha \@*/alpha \@*ALPHA \@/ALPHA \@*/ALPHA
beta   \@beta               \@BETA                         |\@*beta \@/beta \@*/beta   \@*BETA \@/BETA \@*/BETA
gamma  \@gamma [\@!gamma]    \@GAMMA (\@GAMMASC) [\@!GAMMA]   |\@*gamma \@/gamma \@*/gamma   \@*GAMMA \@/GAMMA \@*/GAMMA
...
sigma  \@sigma (\@sigmafn)   \@SIGMA [\@!SIGMA]              |\@*sigma \@/sigma \@*/sigma   \@*SIGMA \@/SIGMA \@*/SIGMA
...
psi    \@psi                \@PSI   (\@PSISC)               |\@*psi \@/psi \@*/psi   \@*PSI \@/PSI \@*/PSI
omega  \@omega              \@OMEGA                        |\@*omega \@/omega \@*/omega   \@*OMEGA \@/OMEGA \@*/OMEGA

  Table showing Greek characters by name.

      Small       Capital         |Bold
       (final)     (small)        |  Italic
Name     [dbl]       [dbl]        |    Bold+Italic
alpha    α           Α            |𝝰 𝛼 𝞪   𝝖 𝛢 𝞐
beta     β           Β            |𝝱 𝛽 𝞫   𝝗 𝛣 𝞑
gamma    γ [ℽ ]      Γ (ᴦ) [ℾ ]   |𝝲 𝛾 𝞬   𝝘 𝛤 𝞒
delta    δ           Δ            |𝝳 𝛿 𝞭   𝝙 𝛥 𝞓
epsilon  ε           Ε            |𝝴 𝜀 𝞮   𝝚 𝛦 𝞔
zeta     ζ           Ζ            |𝝵 𝜁 𝞯   𝝛 𝛧 𝞕
eta      η           Η            |𝝶 𝜂 𝞰   𝝜 𝛨 𝞖
theta    θ           Θ            |𝝷 𝜃 𝞱   𝝝 𝛩 𝞗
iota     ι           Ι            |𝝸 𝜄 𝞲   𝝞 𝛪 𝞘
kappa    κ           Κ            |𝝹 𝜅 𝞳   𝝟 𝛫 𝞙
lamda    λ           Λ (ᴧ)        |𝝺 𝜆 𝞴   𝝠 𝛬 𝞚
mu       μ           Μ            |𝝻 𝜇 𝞵   𝝡 𝛭 𝞛
nu       ν           Ν            |𝝼 𝜈 𝞶   𝝢 𝛮 𝞜
xi       ξ           Ξ            |𝝽 𝜉 𝞷   𝝣 𝛯 𝞝
omicron  ο           Ο            |𝝾 𝜊 𝞸   𝝤 𝛰 𝞞
pi       π [ℼ ]      Π (ᴨ) [ℿ ]   |𝝿 𝜋 𝞹   𝝥 𝛱 𝞟
rho      ρ           Ρ (ᴩ)        |𝞀 𝜌 𝞺   𝝦 𝛲 𝞠
sigma    σ (ς)       Σ [⅀ ]       |𝞂 𝜎 𝞼   𝝨 𝛴 𝞢
tau      τ           Τ            |𝞃 𝜏 𝞽   𝝩 𝛵 𝞣
upsilon  υ           Υ            |𝞄 𝜐 𝞾   𝝪 𝛶 𝞤
phi      φ           Φ            |𝞅 𝜑 𝞿   𝝫 𝛷 𝞥
chi      χ           Χ            |𝞆 𝜒 𝟀   𝝬 𝛸 𝞦
psi      ψ           Ψ (ᴪ)        |𝞇 𝜓 𝟁   𝝭 𝛹 𝞧
omega    ω           Ω            |𝞈 𝜔 𝟂   𝝮 𝛺 𝞨

Note: there are no unicode characters for \@!alpha \@!ALPHA and many other double struck Greek small and capital letters

Named operators or functions:

\@sqrt \@root3 \@root4
MANPAGE
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	$MAN = $ARGV[0] =~ m{--man}xms;
	usage()
}

my $reSpace = qr{(?:\A|\z|\s)}xms;
my $rePos = qr{[0-9]+([0-9,]*\.?[0-9,]+)?}xms; # positive 0 0.1 1,000.000,000,000
my $isFraction = qr{($rePos/$rePos)};
my $isReciprocal = qr{($rePos/)};

my $notNumber = '(?:\A|[^0-9]|\z)';
my $notLetter = '(?:\A|[^a-zA-Z]|\z)';

# also spaces, all letters needed to spell out symbols
my $subScriptChars   = '.+-*=()<>';
my $superScriptChars = $subScriptChars;

my %TypeNames = ();

my %SubScriptMap = qw{
	0	2080
	1	2081
	2	2082
	3	2083
	4	2084
	5	2085
	6	2086
	7	2087
	8	2088
	9	2089
	.	2024
	+	208A
	-	208B
	*	2E31
	=	208C
	(	208D
	)	208E
	<	02F1
	>	02F2
	<-	02FF
	...	2026
	a	2090
	e	2091
	h	2095
	i	1D62
	j	2C7C
	k	2096
	l	2097
	m	2098
	n	2099
	o	2092
	p	209A
	r	1D63
	s	209B
	t	209C
	u	1D64
	v	1D65
	x	2093
	schwa	2094
	beta	1D66
	gamma	1D67
	rho	1D68
	phi	1D69
	chi	1D6A
};
my $reSubScript = map_to_regex(\%SubScriptMap);

my %SuperScriptMap = qw{
	0	2070
	1	B9
	2	B2
	3	B3
	4	2074
	5	2075
	6	2076
	7	2077
	8	2078
	9	2079
	.	22C5
	+	207A
	-	207B
	*	2D9
	=	207C
	(	207D
	)	207E
	<	2C2
	>	2C3
	a	1D43
	b	1D47
	c	1D9C
	d	1D48
	e	1D49
	f	1DA0
	g	1D4D
	G	1DA2
	h	2B0
	i	2071
	I	1DA6
	j	2B2
	k	1D4F
	l	2E1
	m	1D50
	n	207F
	N	1DB0
	o	1D52
	p	1D56
	r	2B3
	s	2E2
	t	1D57
	u	1D58
	U	1DB8
	v	1D5B
	w	2B7
	x	2E3
	y	2B8
	z	1DBB
	schwa	1D4A
	alpha	1D45
	beta	1D5D
	gamma	1D5E
	GAMMA	2E0
	delta	1D5F
	theta	1DBF
	iota	1DA5
	upsilon	1DB7
	phi	1D60
	PHI	1DB2
	chi	1D61
};
my $reSuperScript = map_to_regex(\%SuperScriptMap);

# @GAMMASC - etc SMALL CAPS markup
my %GreekSmCap = qw(
	GAMMASC     1D26
	LAMDASC     1D27
	PISC        1D28
	RHOSC       1D29
	PSISC       1D2A
);

# @!gamma - etc Double Struck markup
my %GreekDblStk = qw(
	gamma       213D
	pi          213C
	GAMMA       213E
	PI          213F
	SIGMA       2140
);

# @alpha - etc Normal font markup
my %GreekNormal = qw(
	alpha       3B1
	beta        3B2
	gamma       3B3
	delta       3B4
	epsilon     3B5
	zeta        3B6
	eta         3B7
	theta       3B8
	iota        3B9
	kappa       3BA
	lamda       3BB
	mu          3BC
	nu          3BD
	xi          3BE
	omicron     3BF
	pi          3C0
	rho         3C1
	sigma       3C3
	sigmafn     3C2
	finalsigma  3C2
	tau         3C4
	upsilon     3C5
	phi         3C6
	chi         3C7
	psi         3C8
	omega       3C9

	ALPHA       391
	BETA        392
	GAMMA       393
	DELTA       394
	EPSILON     395
	ZETA        396
	ETA         397
	THETA       398
	IOTA        399
	KAPPA       39A
	LAMDA       39B
	MU          39C
	NU          39D
	XI          39E
	OMICRON     39F
	PI          3A0
	RHO         3A1
	SIGMA       3A3
	TAU         3A4
	UPSILON     3A5
	PHI         3A6
	CHI         3A7
	PSI         3A8
	OMEGA       3A9
);

# @/alpha - etc Italic font markup
my %GreekItal = qw(
	alpha       1D6FC
	beta        1D6FD
	gamma       1D6FE
	delta       1D6FF
	epsilon     1D700
	zeta        1D701
	eta         1D702
	theta       1D703
	iota        1D704
	kappa       1D705
	lamda       1D706
	mu          1D707
	nu          1D708
	xi          1D709
	omicron     1D70A
	pi          1D70B
	rho         1D70C
	sigma       1D70E
	sigmafn     1D70D
	finalsigma  1D70D
	tau         1D70F
	upsilon     1D710
	phi         1D711
	chi         1D712
	psi         1D713
	omega       1D714

	ALPHA       1D6E2
	BETA        1D6E3
	GAMMA       1D6E4
	DELTA       1D6E5
	EPSILON     1D6E6
	ZETA        1D6E7
	ETA         1D6E8
	THETA       1D6E9
	IOTA        1D6EA
	KAPPA       1D6EB
	LAMDA       1D6EC
	MU          1D6ED
	NU          1D6EE
	XI          1D6EF
	OMICRON     1D6F0
	PI          1D6F1
	RHO         1D6F2
	SIGMA       1D6F4
	TAU         1D6F5
	UPSILON     1D6F6
	PHI         1D6F7
	CHI         1D6F8
	PSI         1D6F9
	OMEGA       1D6FA
);

# @*alpha - etc Bold font markup
my %GreekBold = qw(
	alpha       1D770
	beta        1D771
	gamma       1D772
	delta       1D773
	epsilon     1D774
	zeta        1D775
	eta         1D776
	theta       1D777
	iota        1D778
	kappa       1D779
	lamda       1D77A
	mu          1D77B
	nu          1D77C
	xi          1D77D
	omicron     1D77E
	pi          1D77F
	rho         1D780
	sigma       1D782
	sigmafn     1D781
	finalsigma  1D781
	tau         1D783
	upsilon     1D784
	phi         1D785
	chi         1D786
	psi         1D787
	omega       1D788

	ALPHA       1D756
	BETA        1D757
	GAMMA       1D758
	DELTA       1D759
	EPSILON     1D75A
	ZETA        1D75B
	ETA         1D75C
	THETA       1D75D
	IOTA        1D75E
	KAPPA       1D75F
	LAMDA       1D760
	MU          1D761
	NU          1D762
	XI          1D763
	OMICRON     1D764
	PI          1D765
	RHO         1D766
	SIGMA       1D768
	TAU         1D769
	UPSILON     1D76A
	PHI         1D76B
	CHI         1D76C
	PSI         1D76D
	OMEGA       1D76E
);

# @*/alpha - etc Bold Italic font markup
my %GreekBoldItal = qw(
	alpha       1D7AA
	beta        1D7AB
	gamma       1D7AC
	delta       1D7AD
	epsilon     1D7AE
	zeta        1D7AF
	eta         1D7B0
	theta       1D7B1
	iota        1D7B2
	kappa       1D7B3
	lamda       1D7B4
	mu          1D7B5
	nu          1D7B6
	xi          1D7B7
	omicron     1D7B8
	pi          1D7B9
	rho         1D7BA
	sigma       1D7BC
	sigmafn     1D7BB
	finalsigma  1D7BB
	tau         1D7BD
	upsilon     1D7BE
	phi         1D7BF
	chi         1D7C0
	psi         1D7C1
	omega       1D7C2

	ALPHA       1D790
	BETA        1D791
	GAMMA       1D792
	DELTA       1D793
	EPSILON     1D794
	ZETA        1D795
	ETA         1D796
	THETA       1D797
	IOTA        1D798
	KAPPA       1D799
	LAMDA       1D79A
	MU          1D79B
	NU          1D79C
	XI          1D79D
	OMICRON     1D79E
	PI          1D79F
	RHO         1D7A0
	SIGMA       1D7A2
	TAU         1D7A3
	UPSILON     1D7A4
	PHI         1D7A5
	CHI         1D7A6
	PSI         1D7A7
	OMEGA       1D7A8
);

my %Greek = %GreekNormal;

# replacement map and array ordered longest to shortest
my @Replacements = ();
my %Replacements = ();

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

# sorting function for longest to shortest string length
sub byLength
{
	return length($b) - length($a);
}

# convert the keys of a hash map into a regular expression for matching longest to shortest
sub map_to_regex
{
	my ($rhMap) = @ARG;
	my @Order = sort byLength %$rhMap;
	my $regex = join("|", map { quotemeta($ARG) } @Order);
	return $regex;
}

# Populate the Replacements map and array with configuration
sub replacer
{
	my ($type, $literal, $code, $enabled) = @ARG;
	#debug("replacer($type, $literal, U+$code, @{[$enabled ? 'on':'off']})");
	if ($enabled)
	{
		my $raReplace = [];
		if ($Replacements{$literal})
		{
			$raReplace = $Replacements{$literal};
			warn "WARN: replacer '$raReplace->[0]{type}'('$literal', 'U+$raReplace->[0]{code}') already added, adding '$type'('$literal', 'U+$code') after it.";
		}
		else
		{
			push(@Replacements, $literal);
			$Replacements{$literal} = $raReplace;
		}
		push(@$raReplace,
			  { search => $literal, type => $type, code => $code }
		);
      # test the replacement code and populate the TypeNames lookup
		replace("", $literal, $type, $code);
	}
} # replacer()

# search and replace a specific type of replacement on a line.
sub search
{
	my ($line, $search, $type, $code) = @ARG;
	debug("search: $search rep: $type U+$code [$TypeNames{$type}]") if $TypeNames{$type};
	if ($type eq 'sy')
	{
		$line = sy($line, $search, $code);
	}
	elsif ($type eq 'sys')
	{
		$line = sys($line, $search, $code);
	}
	elsif ($type eq 'syw')
	{
		$line = syw($line, $search, $code);
	}
	elsif ($type eq 'ww')
	{
		$line = ww($line, $search, $code);
	}
	elsif ($type eq 'wws')
	{
		$line = wws($line, $search, $code);
	}
	elsif ($type eq 'nn')
	{
		$line = nn($line, $search, $code);
	}
	elsif ($type eq 'nd')
	{
		$line = nd($line, $search, $code);
	}
	else
	{
		die qq{Unknown replacement type '$type' for search '$search'}
	}
	return $line;
} # search()

# perform all replacement types on a line.
sub replace
{
	my ($line) = @ARG;
	debug("line  in: $line");
	foreach my $search (@Replacements)
	{
		my $raReplace = $Replacements{$search};
		foreach my $rhSearch (@$raReplace)
		{
			my $type = $rhSearch->{type};
			my $code = $rhSearch->{code};

			$line = search($line, $search, $type, $code);
		}
	}
	debug("line out: $line");
	return $line;
} # replace()

# Perform a symbol change to the line of text.
# Normally will just return the $replace value to finalise a replacement.
# In --legend mode we want to show the matched value beside the replaced value on the same line so we create a numbered match map containing the matched text mapped to the replace text and a map of @number to $matched so it can be used by changeBack() function
my $matchNum = 0;
my %MatchNum = ();
my %Matched = ();

# TODO finish this up...
sub change
{
	my ($matched, $replace, $quoted) = @ARG;
	if ($Matched{$matched})
	{
		$replace = $Matched{$matched} if $LEGEND;
	} else
	{
		my $id = "\@$matchNum";
		$Matched{$matched} = $id;
		$MatchNum{$id} = $matched;
		++$matchNum;
	}
	return $replace;
} # change()

# Change all @0 @23 @123 numbered matches back into their original symbol names/literals for LEGEND mode.
sub changeBack
{
	my ($line) = @ARG;
	$line =~ s{(\@\d+)}{$MatchNum{$1} || $1}xmsge;
	return $line;
}

# purpose of this was to give an error if a shorter literal is searched for before a longer literal but we sort the @Replacements array now so it is irrelevant
sub checkLength
{
	my ($literal) = @ARG;
	return $literal;
}

# code point to utf8 character
sub toUTF8
{
	my ($hex) = @ARG;
	my $ret = charnames::string_vianame(uc("U+$hex"));
	return $ret;
}

# show unicode code or actual character
sub U
{
	my ($code) = @ARG;
	if ($SHOW_CODE)
	{
		return qq{{U+$code}};
	}
	else
	{
		return toUTF8($code);
	}
}

# lookup the unicode character to replace with from a hash map.
sub lookup
{
	my ($match, $rhSymbolMap, $context) = @ARG;
	my $code = $rhSymbolMap->{$match} || '';
	debug(qq{lookup([$match] => @{[$code ? "U+$code" : "n/a"]}): context: $context});
	if ($match !~ m{\s}xms && !$code)
	{
		warn qq{WARN: $context, No unicode replacement configured for '$match', will not replace.};
	}
	return $code ? yes(U($code)) : $match;
}

# translate a matched string to the unicode character from a hash map.
sub translate
{
	my ($match, $escape, $rhSymbolMap, $reMatcher) = @ARG;

	my $output = '';
	my $context = qq{In bracketed sequence $escape\[};
	debug("translate($match, $escape)");

	# Need to match only at start of string from longest to shortest removing
	# matches as we go, warning about non-matches
	while (length($match))
	{
		if ($match =~ s{\A($reMatcher)}{}xms)
		{
			my $token = $1;
			$output .= lookup($token, $rhSymbolMap, "$context$token$match]");
		}
		else
		{
			$match =~ s{\A(.)}{}xms;
			my $char = $1;
			$output .= $char;
			if ($char !~ m{\A\s}xms)
			{
				warn qq{WARN: $char$match], No unicode replacement configured for '$char', will not replace.};
			}
		}
	}

	return $output;
} # translate()

# replace square bracketed runs of text ie. _[(n+1)(n-1)]
sub sb
{
	my ($line, $escape, $chars, $rhSymbolMap, $reMatcher, $enabled) = @ARG;
	$TypeNames{'sb'} = "square bracketed runs of text";
	if ($enabled)
	{
		my $esc = quotemeta($escape . '[');
		my $quoted = quotemeta($chars);
		my $re = qr{$esc([\s0-9a-zA-Z$quoted]+)\]}xms;
		debug("sb($re): $line");
		$line =~ s{$re}{yes(translate($1, $escape, $rhSymbolMap, $reMatcher))}xmsge;
	}
	return $line;
}

# replace a symbol surrounded by whitespace
sub sys
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'sys'} = "literal string of symbols (like >=) surrounded by whitespace replaced with a single symbol character with or without the space (CUDDLE option)";
	my $quoted = quotemeta(checkLength($literal));
	debug("sys(\\s$quoted\\s => U+$code): line: $line");
# TODO CUDDLE OPTION
	$line =~ s{($reSpace)$quoted($reSpace)}{$1 . legend($literal, yes(U($code)), $quoted) . $2}xmsge;
	return $line;
}

# replace a literal symbol ie. _s
sub sy
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'sy'} = "literal string of symbols (like ^2 _n) replaced with a single symbol character";
	my $quoted = quotemeta(checkLength($literal));
	debug("sy($quoted => U+$code): line: $line");
	$line =~ s{$quoted}{legend($literal, yes(U($code)), $quoted)}xmsge;
	return $line;
}

# replace a literal full word ie. @theta
sub ww
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'ww'} = "literal \@named character replaced with a single corresponding character";
	my $quoted = quotemeta(checkLength($literal));
	debug("ww($quoted => U+$code): line: $line");
	$line =~ s{($notLetter)$quoted($notLetter)}{$1 . legend($literal, yes(U($code), $quoted)) . $2}xmsge;
	return $line;
}

# replace a literal full word with optional space after it ie. @sqrt 42 @sqrt(43)
sub wws
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'wws'} = "literal \@named character with optional space after it replaced with a single corresponding character";
	my $quoted = quotemeta(checkLength($literal)) . "[ ]?";
	debug("wws($quoted => U+$code): line: $line");
	$line =~ s{($notLetter)$quoted($notLetter)}{$1 . legend($literal, yes(U($code), $quoted)) . $2}xmsge;
	return $line;
}


# replace a literal word symbol ie. _theta
sub syw
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'syw'} = "literal string of word characters (like _theta) replaced with a single symbol character";
	my $quoted = quotemeta(checkLength($literal));
	debug("syw($quoted => U+$code): line: $line");
	$line =~ s{$quoted($notLetter)}{legend($literal, yes(U($code), $quoted)) . $1}xmsge;
	return $line;
}

sub pad
{
  my ($number, $places) = @ARG;
  $places = $places || 6;
  return $number . (' ' x ($places - length($number)));
}

sub legend
{
	my ($literal, $replacement, $quoted) = @ARG;
	my $padded = pad($literal, $PAD_NAMES);
	my $padchar = pad($replacement, $PAD_CHARS);
	if ($LEGEND eq "names")
	{
		print "$INDENT$padded $padchar$SEP\n";
	} elsif ($LEGEND eq "chars")
	{
		print "$INDENT$padchar $padded$SEP\n";
	}
	return $replacement;
}

# replace a fraction if it matches the literal value. ie. 1/3
sub replaceFraction
{
	my ($fraction, $literal, $code) = @ARG;
	debug("replaceFraction?($fraction eq $literal => U+$code)");
	return ($fraction eq $literal) ? legend($literal, yes(U($code), $literal)) : $fraction;
}

# replace a literal surrounded by non-numbers ie. 1/3
# First match a literal fraction before making the substitution...
sub nn
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'nn'} = "literal fractions (like 1/9) replaced with specific fraction characters";
	$literal = checkLength($literal);
	debug("nn($literal => U+$code): line: $line");
	$line =~ s{$isFraction}{replaceFraction($1, $literal, $code)}xmsge;
	return $line;
}

# replace a literal preceded by non-number but followed by numbers ie. 1/3000
sub nd
{
	my ($line, $literal, $code) = @ARG;
	$TypeNames{'nn'} = "literal reciprocal fraction (like 1/x)  replaced with reciprocal character";
	$literal = checkLength($literal);
	debug("nd($literal => U+$code): line: $line");
	$line =~ s{$isReciprocal}{replaceFraction($1, $literal, $code)}xmsge;
	return $line;
}

# construct the parser replacements in order of reverse length
sub makeParser
{
	debug("makeParser begin");
	my $saved_debug = $DEBUG;
	$DEBUG = 0;

	# Fractions:
	replacer('nn', '1/10', '2152', $LITERAL);
	replacer('nn', '1/4', 'BC',    $LITERAL);
	replacer('nn', '1/2', 'BD',    $LITERAL);
	replacer('nn', '3/4', 'BE',    $LITERAL);
	replacer('nn', '1/7', '2150', $LITERAL);
	replacer('nn', '1/9', '2151', $LITERAL);
	replacer('nn', '1/3', '2153', $LITERAL);
	replacer('nn', '2/3', '2154', $LITERAL);
	replacer('nn', '1/5', '2155', $LITERAL);
	replacer('nn', '2/5', '2156', $LITERAL);
	replacer('nn', '3/5', '2157', $LITERAL);
	replacer('nn', '4/5', '2158', $LITERAL);
	replacer('nn', '1/6', '2159', $LITERAL);
	replacer('nn', '5/6', '215A', $LITERAL);
	replacer('nn', '1/8', '215B', $LITERAL);
	replacer('nn', '3/8', '215C', $LITERAL);
	replacer('nn', '5/8', '215D', $LITERAL);
	replacer('nn', '7/8', '215E', $LITERAL);
	replacer('nn', '0/3', '2189', $LITERAL);
	replacer('nd', '1/', '215F', $LITERAL); # TODO needs a thin unicode space

	# Operators and Equalities/inequalities:
	replacer('sy', '+-', 'B1',   $LITERAL);
	replacer('sy', '**', 'D7',   $LITERAL);
	replacer('sy', '//', 'F7',   $LITERAL);
	replacer('sy', '!!', 'AC',   $LITERAL);

	replacer('sys', '=/=', '2260', $LITERAL);
	replacer('sys', '==', '2261', $LITERAL);
	replacer('sys', '=/=/', '2262', $LITERAL);
	replacer('sys', '===', '2263', $LITERAL);

	replacer('sys', '<=', '2264', $LITERAL);
	replacer('sys', '>=', '2265', $LITERAL);
	replacer('sys', '<==', '2266', $LITERAL);
	replacer('sys', '>==', '2267', $LITERAL);
	replacer('sys', '<=/=/', '2268', $LITERAL);
	replacer('sys', '>=/=/', '2269', $LITERAL);
	replacer('sys', '<<', '226A', $LITERAL);
	replacer('sys', '>>', '226B', $LITERAL);
	replacer('sys', '</', '226E', $LITERAL);
	replacer('sys', '>/', '226F', $LITERAL);
	replacer('sys', '</=/', '2270', $LITERAL);
	replacer('sys', '>/=/', '2271', $LITERAL);
	replacer('sys', '<~', '2272', $LITERAL);
	replacer('sys', '>~', '2273', $LITERAL);
	replacer('sys', '</~/', '2274', $LITERAL);
	replacer('sys', '>/~/', '2275', $LITERAL);
	replacer('sys', '<>', '2276', $LITERAL);
	replacer('sys', '><', '2277', $LITERAL);
	replacer('sys', '</>/', '2278', $LITERAL);
	replacer('sys', '>/</', '2279', $LITERAL);
	replacer('sys', '<.', '22D6', $LITERAL);
	replacer('sys', '>.', '22D7', $LITERAL);
	replacer('sys', '<<<', '22D8', $LITERAL);
	replacer('sys', '>>>', '22D9', $LITERAL);
	replacer('sys', '<=>', '22DA', $LITERAL);
	replacer('sys', '>=<', '22DB', $LITERAL);
	replacer('sys', '=<', '22DC', $LITERAL);
	replacer('sys', '=>', '22DD', $LITERAL);

	replacer('sys', '~/', '2241', $LITERAL);
	replacer('sys', '-~', '2242', $LITERAL);
	replacer('sys', '~=', '2243', $LITERAL);
	replacer('sys', '~/=/', '2244', $LITERAL);
	replacer('sys', '~==', '2245', $LITERAL);
	replacer('sys', '~=/', '2246', $LITERAL);
	replacer('sys', '~/=/=/', '2247', $LITERAL);
	replacer('sys', '~~', '2248', $LITERAL);
	replacer('sys', '~/~/', '2249', $LITERAL);
	replacer('sys', '~~=', '224A', $LITERAL);
	replacer('sys', '~~~', '224B', $LITERAL);
	replacer('sys', '~===', '224C', $LITERAL);

	# Subscript:
	replacer('sy', '_.', '2024', $MARKUP); # looks like subscript decimal point but not official
	replacer('sy', '_*', '2E31', $MARKUP); # looks like subscript multiplication but not official
	replacer('sy', '_0', '2080', $MARKUP);
	replacer('sy', '_1', '2081', $MARKUP);
	replacer('sy', '_2', '2082', $MARKUP);
	replacer('sy', '_3', '2083', $MARKUP);
	replacer('sy', '_4', '2084', $MARKUP);
	replacer('sy', '_5', '2085', $MARKUP);
	replacer('sy', '_6', '2086', $MARKUP);
	replacer('sy', '_7', '2087', $MARKUP);
	replacer('sy', '_8', '2088', $MARKUP);
	replacer('sy', '_9', '2089', $MARKUP);
	replacer('sy', '_a', '2090', $MARKUP);
	replacer('sy', '_e', '2091', $MARKUP);
	replacer('sy', '_h', '2095', $MARKUP);
	replacer('sy', '_i', '1D62', $MARKUP);
	replacer('sy', '_j', '2C7C', $MARKUP);
	replacer('sy', '_k', '2096', $MARKUP);
	replacer('sy', '_l', '2097', $MARKUP);
	replacer('sy', '_m', '2098', $MARKUP);
	replacer('sy', '_n', '2099', $MARKUP);
	replacer('sy', '_o', '2092', $MARKUP);
	replacer('sy', '_p', '209A', $MARKUP);
	replacer('sy', '_r', '1D63', $MARKUP);
	replacer('sy', '_s', '209B', $MARKUP);
	replacer('sy', '_t', '209C', $MARKUP);
	replacer('sy', '_u', '1D64', $MARKUP);
	replacer('sy', '_v', '1D65', $MARKUP);
	replacer('sy', '_x', '2093', $MARKUP);
	replacer('sy', '_+', '208A', $MARKUP);
	replacer('sy', '_-', '208B', $MARKUP);
	replacer('sy', '_=', '208C', $MARKUP);
	replacer('sy', '_(', '208D', $MARKUP);
	replacer('sy', '_)', '208E', $MARKUP);
	replacer('sy', '_<', '02F1', $MARKUP);
	replacer('sy', '_>', '02F2', $MARKUP);
	replacer('sy', '_...', '2026', $MARKUP);
	replacer('sy', '_<-', '02FF', $MARKUP);

	replacer('syw', '_schwa', '2094', $MARKUP); # e upside down

	replacer('syw', '_beta', '1D66', $MARKUP);
	replacer('syw', '_gamma', '1D67', $MARKUP);
	replacer('syw', '_rho', '1D68', $MARKUP);
	replacer('syw', '_phi', '1D69', $MARKUP);
	replacer('syw', '_chi', '1D6A', $MARKUP);

	# Superscript:
	replacer('sy', '^.', '22C5', $MARKUP); # not officially a superscript decimal point but it works.
	replacer('sy', '^*', '2D9', $MARKUP); # looks like superscript multiplication
	replacer('sy', '^0', '2070', $MARKUP);
	replacer('sy', '^1', 'B9', $MARKUP);
	replacer('sy', '^2', 'B2', $MARKUP);
	replacer('sy', '^3', 'B3', $MARKUP);
	replacer('sy', '^4', '2074', $MARKUP);
	replacer('sy', '^5', '2075', $MARKUP);
	replacer('sy', '^6', '2076', $MARKUP);
	replacer('sy', '^7', '2077', $MARKUP);
	replacer('sy', '^8', '2078', $MARKUP);
	replacer('sy', '^9', '2079', $MARKUP);
	replacer('sy', '^a', '1D43', $MARKUP);
	replacer('sy', '^b', '1D47', $MARKUP);
	replacer('sy', '^c', '1D9C', $MARKUP);
	replacer('sy', '^d', '1D48', $MARKUP);
	replacer('sy', '^e', '1D49', $MARKUP);
	replacer('sy', '^f', '1DA0', $MARKUP);
	replacer('sy', '^g', '1D4D', $MARKUP);
	replacer('sy', '^G', '1DA2', $MARKUP);
	replacer('sy', '^h', '2B0', $MARKUP);
	replacer('sy', '^i', '2071', $MARKUP);
	replacer('sy', '^I', '1DA6', $MARKUP);
	replacer('sy', '^j', '2B2', $MARKUP);
	replacer('sy', '^k', '1D4F', $MARKUP);
	replacer('sy', '^l', '2E1', $MARKUP);
	replacer('sy', '^m', '1D50', $MARKUP);
	replacer('sy', '^n', '207F', $MARKUP);
	replacer('sy', '^N', '1DB0', $MARKUP);
	replacer('sy', '^o', '1D52', $MARKUP);
	replacer('sy', '^p', '1D56', $MARKUP);
	replacer('sy', '^r', '2B3', $MARKUP);
	replacer('sy', '^s', '2E2', $MARKUP);
	replacer('sy', '^t', '1D57', $MARKUP);
	replacer('sy', '^u', '1D58', $MARKUP);
	replacer('sy', '^U', '1DB8', $MARKUP);
	replacer('sy', '^v', '1D5B', $MARKUP);
	replacer('sy', '^w', '2B7', $MARKUP);
	replacer('sy', '^x', '2E3', $MARKUP);
	replacer('sy', '^y', '2B8', $MARKUP);
	replacer('sy', '^z', '1DBB', $MARKUP);

	replacer('sy', '^+', '207A', $MARKUP);
	replacer('sy', '^-', '207B', $MARKUP);
	replacer('sy', '^=', '207C', $MARKUP);
	replacer('sy', '^(', '207D', $MARKUP);
	replacer('sy', '^)', '207E', $MARKUP);
	replacer('sy', '^<', '2C2', $MARKUP);
	replacer('sy', '^>', '2C3', $MARKUP);

	replacer('sy', '^schwa', '1D4A', $MARKUP);

	replacer('sy', '^alpha', '1D45', $MARKUP);
	replacer('sy', '^beta', '1D5D', $MARKUP);
	replacer('sy', '^gamma', '1D5E', $MARKUP);
	replacer('sy', '^GAMMA', '2E0', $MARKUP);
	replacer('sy', '^delta', '1D5F', $MARKUP);
	replacer('sy', '^theta', '1DBF', $MARKUP);
	replacer('sy', '^iota', '1DA5', $MARKUP);
	replacer('sy', '^upsilon', '1DB7', $MARKUP);
	replacer('sy', '^phi', '1D60', $MARKUP);
	replacer('sy', '^PHI', '1DB2', $MARKUP);
	replacer('sy', '^chi', '1D61', $MARKUP);

	# Named functions or operators with optional space after it
	replacer('wws', '@sqrt', '221A', $MARKUP);
	replacer('wws', '@root3', '221B', $MARKUP);
	replacer('wws', '@root4', '221C', $MARKUP);

	# Greek Small Caps incidentals
	replacer('ww', '@GAMMASC', $GreekSmCap{GAMMASC}, $MARKUP);
	replacer('ww', '@LAMDASC', $GreekSmCap{LAMDASC}, $MARKUP);
	replacer('ww', '@PISC', $GreekSmCap{PISC}, $MARKUP);
	replacer('ww', '@RHOSC', $GreekSmCap{RHOSC}, $MARKUP);
	replacer('ww', '@PSISC', $GreekSmCap{PSISC}, $MARKUP);

	# Greek Double Struck incidentals
	replacer('ww', '@!gamma', $GreekDblStk{gamma}, $MARKUP);
	replacer('ww', '@!GAMMA', $GreekDblStk{GAMMA}, $MARKUP);
	replacer('ww', '@!pi', $GreekDblStk{pi}, $MARKUP);
	replacer('ww', '@!PI', $GreekDblStk{PI}, $MARKUP);
	replacer('ww', '@!SIGMA', $GreekDblStk{SIGMA}, $MARKUP);

	# Greek Small and Capital
	replacer('ww', '@alpha', $Greek{alpha}, $MARKUP);
	replacer('ww', '@ALPHA', $Greek{ALPHA}, $MARKUP);
	replacer('ww', '@beta', $Greek{beta}, $MARKUP);
	replacer('ww', '@BETA', $Greek{BETA}, $MARKUP);
	replacer('ww', '@gamma', $Greek{gamma}, $MARKUP);
	replacer('ww', '@GAMMA', $Greek{GAMMA}, $MARKUP);
	replacer('ww', '@delta', $Greek{delta}, $MARKUP);
	replacer('ww', '@DELTA', $Greek{DELTA}, $MARKUP);
	replacer('ww', '@epsilon', $Greek{epsilon}, $MARKUP);
	replacer('ww', '@EPSILON', $Greek{EPSILON}, $MARKUP);
	replacer('ww', '@zeta', $Greek{zeta}, $MARKUP);
	replacer('ww', '@ZETA', $Greek{ZETA}, $MARKUP);
	replacer('ww', '@eta', $Greek{eta}, $MARKUP);
	replacer('ww', '@ETA', $Greek{ETA}, $MARKUP);
	replacer('ww', '@theta', $Greek{theta}, $MARKUP);
	replacer('ww', '@THETA', $Greek{THETA}, $MARKUP);
	replacer('ww', '@iota', $Greek{iota}, $MARKUP);
	replacer('ww', '@IOTA', $Greek{IOTA}, $MARKUP);
	replacer('ww', '@kappa', $Greek{kappa}, $MARKUP);
	replacer('ww', '@KAPPA', $Greek{KAPPA}, $MARKUP);
	replacer('ww', '@lamda', $Greek{lamda}, $MARKUP);
	replacer('ww', '@LAMDA', $Greek{LAMDA}, $MARKUP);
	replacer('ww', '@mu', $Greek{mu}, $MARKUP);
	replacer('ww', '@MU', $Greek{MU}, $MARKUP);
	replacer('ww', '@nu', $Greek{nu}, $MARKUP);
	replacer('ww', '@NU', $Greek{NU}, $MARKUP);
	replacer('ww', '@xi', $Greek{xi}, $MARKUP);
	replacer('ww', '@XI', $Greek{XI}, $MARKUP);
	replacer('ww', '@omicron', $Greek{omicron}, $MARKUP);
	replacer('ww', '@OMICRON', $Greek{OMICRON}, $MARKUP);
	replacer('ww', '@pi', $Greek{pi}, $MARKUP);
	replacer('ww', '@PI', $Greek{PI}, $MARKUP);
	replacer('ww', '@rho', $Greek{rho}, $MARKUP);
	replacer('ww', '@RHO', $Greek{RHO}, $MARKUP);
	replacer('ww', '@sigma', $Greek{sigma}, $MARKUP);
	replacer('ww', '@SIGMA', $Greek{SIGMA}, $MARKUP);
	replacer('ww', '@sigmafn', $Greek{finalsigma}, $MARKUP);#DEPRECATED
	replacer('ww', '@sigmafn', $Greek{sigmafn}, $MARKUP);
	replacer('ww', '@tau', $Greek{tau}, $MARKUP);
	replacer('ww', '@TAU', $Greek{TAU}, $MARKUP);
	replacer('ww', '@upsilon', $Greek{upsilon}, $MARKUP);
	replacer('ww', '@UPSILON', $Greek{UPSILON}, $MARKUP);
	replacer('ww', '@phi', $Greek{phi}, $MARKUP);
	replacer('ww', '@PHI', $Greek{PHI}, $MARKUP);
	replacer('ww', '@chi', $Greek{chi}, $MARKUP);
	replacer('ww', '@CHI', $Greek{CHI}, $MARKUP);
	replacer('ww', '@psi', $Greek{psi}, $MARKUP);
	replacer('ww', '@PSI', $Greek{PSI}, $MARKUP);
	replacer('ww', '@omega', $Greek{omega}, $MARKUP);
	replacer('ww', '@OMEGA', $Greek{OMEGA}, $MARKUP);

	# Greek Bold Small and Capital
	replacer('ww', '@*alpha', $GreekBold{alpha}, $MARKUP);
	replacer('ww', '@*ALPHA', $GreekBold{ALPHA}, $MARKUP);
	replacer('ww', '@*beta', $GreekBold{beta}, $MARKUP);
	replacer('ww', '@*BETA', $GreekBold{BETA}, $MARKUP);
	replacer('ww', '@*gamma', $GreekBold{gamma}, $MARKUP);
	replacer('ww', '@*GAMMA', $GreekBold{GAMMA}, $MARKUP);
	replacer('ww', '@*delta', $GreekBold{delta}, $MARKUP);
	replacer('ww', '@*DELTA', $GreekBold{DELTA}, $MARKUP);
	replacer('ww', '@*epsilon', $GreekBold{epsilon}, $MARKUP);
	replacer('ww', '@*EPSILON', $GreekBold{EPSILON}, $MARKUP);
	replacer('ww', '@*zeta', $GreekBold{zeta}, $MARKUP);
	replacer('ww', '@*ZETA', $GreekBold{ZETA}, $MARKUP);
	replacer('ww', '@*eta', $GreekBold{eta}, $MARKUP);
	replacer('ww', '@*ETA', $GreekBold{ETA}, $MARKUP);
	replacer('ww', '@*theta', $GreekBold{theta}, $MARKUP);
	replacer('ww', '@*THETA', $GreekBold{THETA}, $MARKUP);
	replacer('ww', '@*iota', $GreekBold{iota}, $MARKUP);
	replacer('ww', '@*IOTA', $GreekBold{IOTA}, $MARKUP);
	replacer('ww', '@*kappa', $GreekBold{kappa}, $MARKUP);
	replacer('ww', '@*KAPPA', $GreekBold{KAPPA}, $MARKUP);
	replacer('ww', '@*lamda', $GreekBold{lamda}, $MARKUP);
	replacer('ww', '@*LAMDA', $GreekBold{LAMDA}, $MARKUP);
	replacer('ww', '@*mu', $GreekBold{mu}, $MARKUP);
	replacer('ww', '@*MU', $GreekBold{MU}, $MARKUP);
	replacer('ww', '@*nu', $GreekBold{nu}, $MARKUP);
	replacer('ww', '@*NU', $GreekBold{NU}, $MARKUP);
	replacer('ww', '@*xi', $GreekBold{xi}, $MARKUP);
	replacer('ww', '@*XI', $GreekBold{XI}, $MARKUP);
	replacer('ww', '@*omicron', $GreekBold{omicron}, $MARKUP);
	replacer('ww', '@*OMICRON', $GreekBold{OMICRON}, $MARKUP);
	replacer('ww', '@*pi', $GreekBold{pi}, $MARKUP);
	replacer('ww', '@*PI', $GreekBold{PI}, $MARKUP);
	replacer('ww', '@*rho', $GreekBold{rho}, $MARKUP);
	replacer('ww', '@*RHO', $GreekBold{RHO}, $MARKUP);
	replacer('ww', '@*sigma', $GreekBold{sigma}, $MARKUP);
	replacer('ww', '@*SIGMA', $GreekBold{SIGMA}, $MARKUP);
	replacer('ww', '@*sigmafn', $GreekBold{finalsigma}, $MARKUP);
	replacer('ww', '@*tau', $GreekBold{tau}, $MARKUP);
	replacer('ww', '@*TAU', $GreekBold{TAU}, $MARKUP);
	replacer('ww', '@*upsilon', $GreekBold{upsilon}, $MARKUP);
	replacer('ww', '@*UPSILON', $GreekBold{UPSILON}, $MARKUP);
	replacer('ww', '@*phi', $GreekBold{phi}, $MARKUP);
	replacer('ww', '@*PHI', $GreekBold{PHI}, $MARKUP);
	replacer('ww', '@*chi', $GreekBold{chi}, $MARKUP);
	replacer('ww', '@*CHI', $GreekBold{CHI}, $MARKUP);
	replacer('ww', '@*psi', $GreekBold{psi}, $MARKUP);
	replacer('ww', '@*PSI', $GreekBold{PSI}, $MARKUP);
	replacer('ww', '@*omega', $GreekBold{omega}, $MARKUP);
	replacer('ww', '@*OMEGA', $GreekBold{OMEGA}, $MARKUP);

	# Greek italic Small and Capital
	replacer('ww', '@/alpha', $GreekItal{alpha}, $MARKUP);
	replacer('ww', '@/ALPHA', $GreekItal{ALPHA}, $MARKUP);
	replacer('ww', '@/beta', $GreekItal{beta}, $MARKUP);
	replacer('ww', '@/BETA', $GreekItal{BETA}, $MARKUP);
	replacer('ww', '@/gamma', $GreekItal{gamma}, $MARKUP);
	replacer('ww', '@/GAMMA', $GreekItal{GAMMA}, $MARKUP);
	replacer('ww', '@/delta', $GreekItal{delta}, $MARKUP);
	replacer('ww', '@/DELTA', $GreekItal{DELTA}, $MARKUP);
	replacer('ww', '@/epsilon', $GreekItal{epsilon}, $MARKUP);
	replacer('ww', '@/EPSILON', $GreekItal{EPSILON}, $MARKUP);
	replacer('ww', '@/zeta', $GreekItal{zeta}, $MARKUP);
	replacer('ww', '@/ZETA', $GreekItal{ZETA}, $MARKUP);
	replacer('ww', '@/eta', $GreekItal{eta}, $MARKUP);
	replacer('ww', '@/ETA', $GreekItal{ETA}, $MARKUP);
	replacer('ww', '@/theta', $GreekItal{theta}, $MARKUP);
	replacer('ww', '@/THETA', $GreekItal{THETA}, $MARKUP);
	replacer('ww', '@/iota', $GreekItal{iota}, $MARKUP);
	replacer('ww', '@/IOTA', $GreekItal{IOTA}, $MARKUP);
	replacer('ww', '@/kappa', $GreekItal{kappa}, $MARKUP);
	replacer('ww', '@/KAPPA', $GreekItal{KAPPA}, $MARKUP);
	replacer('ww', '@/lamda', $GreekItal{lamda}, $MARKUP);
	replacer('ww', '@/LAMDA', $GreekItal{LAMDA}, $MARKUP);
	replacer('ww', '@/mu', $GreekItal{mu}, $MARKUP);
	replacer('ww', '@/MU', $GreekItal{MU}, $MARKUP);
	replacer('ww', '@/nu', $GreekItal{nu}, $MARKUP);
	replacer('ww', '@/NU', $GreekItal{NU}, $MARKUP);
	replacer('ww', '@/xi', $GreekItal{xi}, $MARKUP);
	replacer('ww', '@/XI', $GreekItal{XI}, $MARKUP);
	replacer('ww', '@/omicron', $GreekItal{omicron}, $MARKUP);
	replacer('ww', '@/OMICRON', $GreekItal{OMICRON}, $MARKUP);
	replacer('ww', '@/pi', $GreekItal{pi}, $MARKUP);
	replacer('ww', '@/PI', $GreekItal{PI}, $MARKUP);
	replacer('ww', '@/rho', $GreekItal{rho}, $MARKUP);
	replacer('ww', '@/RHO', $GreekItal{RHO}, $MARKUP);
	replacer('ww', '@/sigma', $GreekItal{sigma}, $MARKUP);
	replacer('ww', '@/SIGMA', $GreekItal{SIGMA}, $MARKUP);
	replacer('ww', '@/sigmafn', $GreekItal{finalsigma}, $MARKUP);
	replacer('ww', '@/tau', $GreekItal{tau}, $MARKUP);
	replacer('ww', '@/TAU', $GreekItal{TAU}, $MARKUP);
	replacer('ww', '@/upsilon', $GreekItal{upsilon}, $MARKUP);
	replacer('ww', '@/UPSILON', $GreekItal{UPSILON}, $MARKUP);
	replacer('ww', '@/phi', $GreekItal{phi}, $MARKUP);
	replacer('ww', '@/PHI', $GreekItal{PHI}, $MARKUP);
	replacer('ww', '@/chi', $GreekItal{chi}, $MARKUP);
	replacer('ww', '@/CHI', $GreekItal{CHI}, $MARKUP);
	replacer('ww', '@/psi', $GreekItal{psi}, $MARKUP);
	replacer('ww', '@/PSI', $GreekItal{PSI}, $MARKUP);
	replacer('ww', '@/omega', $GreekItal{omega}, $MARKUP);
	replacer('ww', '@/OMEGA', $GreekItal{OMEGA}, $MARKUP);

	# Greek bold italic Small and Capital
	replacer('ww', '@*/alpha', $GreekBoldItal{alpha}, $MARKUP);
	replacer('ww', '@*/ALPHA', $GreekBoldItal{ALPHA}, $MARKUP);
	replacer('ww', '@*/beta', $GreekBoldItal{beta}, $MARKUP);
	replacer('ww', '@*/BETA', $GreekBoldItal{BETA}, $MARKUP);
	replacer('ww', '@*/gamma', $GreekBoldItal{gamma}, $MARKUP);
	replacer('ww', '@*/GAMMA', $GreekBoldItal{GAMMA}, $MARKUP);
	replacer('ww', '@*/delta', $GreekBoldItal{delta}, $MARKUP);
	replacer('ww', '@*/DELTA', $GreekBoldItal{DELTA}, $MARKUP);
	replacer('ww', '@*/epsilon', $GreekBoldItal{epsilon}, $MARKUP);
	replacer('ww', '@*/EPSILON', $GreekBoldItal{EPSILON}, $MARKUP);
	replacer('ww', '@*/zeta', $GreekBoldItal{zeta}, $MARKUP);
	replacer('ww', '@*/ZETA', $GreekBoldItal{ZETA}, $MARKUP);
	replacer('ww', '@*/eta', $GreekBoldItal{eta}, $MARKUP);
	replacer('ww', '@*/ETA', $GreekBoldItal{ETA}, $MARKUP);
	replacer('ww', '@*/theta', $GreekBoldItal{theta}, $MARKUP);
	replacer('ww', '@*/THETA', $GreekBoldItal{THETA}, $MARKUP);
	replacer('ww', '@*/iota', $GreekBoldItal{iota}, $MARKUP);
	replacer('ww', '@*/IOTA', $GreekBoldItal{IOTA}, $MARKUP);
	replacer('ww', '@*/kappa', $GreekBoldItal{kappa}, $MARKUP);
	replacer('ww', '@*/KAPPA', $GreekBoldItal{KAPPA}, $MARKUP);
	replacer('ww', '@*/lamda', $GreekBoldItal{lamda}, $MARKUP);
	replacer('ww', '@*/LAMDA', $GreekBoldItal{LAMDA}, $MARKUP);
	replacer('ww', '@*/mu', $GreekBoldItal{mu}, $MARKUP);
	replacer('ww', '@*/MU', $GreekBoldItal{MU}, $MARKUP);
	replacer('ww', '@*/nu', $GreekBoldItal{nu}, $MARKUP);
	replacer('ww', '@*/NU', $GreekBoldItal{NU}, $MARKUP);
	replacer('ww', '@*/xi', $GreekBoldItal{xi}, $MARKUP);
	replacer('ww', '@*/XI', $GreekBoldItal{XI}, $MARKUP);
	replacer('ww', '@*/omicron', $GreekBoldItal{omicron}, $MARKUP);
	replacer('ww', '@*/OMICRON', $GreekBoldItal{OMICRON}, $MARKUP);
	replacer('ww', '@*/pi', $GreekBoldItal{pi}, $MARKUP);
	replacer('ww', '@*/PI', $GreekBoldItal{PI}, $MARKUP);
	replacer('ww', '@*/rho', $GreekBoldItal{rho}, $MARKUP);
	replacer('ww', '@*/RHO', $GreekBoldItal{RHO}, $MARKUP);
	replacer('ww', '@*/sigma', $GreekBoldItal{sigma}, $MARKUP);
	replacer('ww', '@*/SIGMA', $GreekBoldItal{SIGMA}, $MARKUP);
	replacer('ww', '@*/sigmafn', $GreekBoldItal{finalsigma}, $MARKUP);
	replacer('ww', '@*/tau', $GreekBoldItal{tau}, $MARKUP);
	replacer('ww', '@*/TAU', $GreekBoldItal{TAU}, $MARKUP);
	replacer('ww', '@*/upsilon', $GreekBoldItal{upsilon}, $MARKUP);
	replacer('ww', '@*/UPSILON', $GreekBoldItal{UPSILON}, $MARKUP);
	replacer('ww', '@*/phi', $GreekBoldItal{phi}, $MARKUP);
	replacer('ww', '@*/PHI', $GreekBoldItal{PHI}, $MARKUP);
	replacer('ww', '@*/chi', $GreekBoldItal{chi}, $MARKUP);
	replacer('ww', '@*/CHI', $GreekBoldItal{CHI}, $MARKUP);
	replacer('ww', '@*/psi', $GreekBoldItal{psi}, $MARKUP);
	replacer('ww', '@*/PSI', $GreekBoldItal{PSI}, $MARKUP);
	replacer('ww', '@*/omega', $GreekBoldItal{omega}, $MARKUP);
	replacer('ww', '@*/OMEGA', $GreekBoldItal{OMEGA}, $MARKUP);

	@Replacements = sort byLength @Replacements;
	#debug("Replacements List: ", join(" ", @Replacements));
	#debug("Replacements Map: ", Dumper(\%Replacements));
   my $faults = 0;
	foreach my $literal (@Replacements)
	{
		my $prefix = "";
		my $raReplace = $Replacements{$literal};
		$faults++ unless $raReplace;
		foreach my $rhReplace (@$raReplace)
		{
			$faults++ unless $rhReplace->{type} && $rhReplace->{code};
			my $type = $rhReplace->{type} || "n/a";
			my $code = $rhReplace->{code} || "n/a";
			#debug(qq{$prefix$literal => $type U+$code});
			$prefix = "   ";
		}
	}
	#debug("${faults} Faults in replacements");
	$DEBUG = $saved_debug;
	debug("makeParser end");
} # makeParser()

sub yes {
	debug("  ^^ YES ^^ [  @{[@ARG]}  ]");
	return wantarray ? @ARG : $ARG[0];
}

sub debug {
	my @stuff = @ARG;
	if ($DEBUG)
	{
		print STDERR (@stuff, "\n");
	}
}

makeParser();

while (my $line = <STDIN>) {
	$line = sb($line, '_', $subScriptChars, \%SubScriptMap, $reSubScript, $MARKUP);
	$line = sb($line, '^', $superScriptChars, \%SuperScriptMap, $reSuperScript, $MARKUP);

	$line = replace($line);
	if (0)
	{

		# TODO convert to replacer() calls
		s{cross}{{U+2A2F}}xmsg;
		s{del}{{U+1D6C1} }xmsg;
		s{dee}{{U+1D6DB}}xmsg;
		s{int}{{U+222B}}xmsg;
		s{dot}{{U+22C5}}xmsg;
		s{sum}{{U+2211}}xmsg;

	}

	print $line unless $LEGEND;
} # while $line
