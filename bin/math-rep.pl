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

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use charnames qw(:full); # :loose if you perl version supports it
use FindBin;

use Data::Dumper;


my $DEBUG = $ENV{DEBUG} || 0;

my $MARKUP = length($ENV{MARKUP}) ? $ENV{MARKUP} : 1; # replace markup codes with characters
my $LITERAL = length($ENV{LITERAL}) ? $ENV{MARKUP} : 1; # replace literal values like 1/4 with their unicode character
my $SHOW_CODE = $ENV{SHOW_CODE} || 0; # show unicode code point value instead of the character

sub usage
{
	my $cmd = $FindBin::Script;

	print <<"USAGE";
$cmd [--help|--man|-?] [--markup] [--literal] [--codes]

TODO Display a description of the program.
MARKUP=$MARKUP
LITERAL=$LITERAL
SHOW_CODE=$SHOW_CODE

--markup TODO...
--literal TODO...
--codes TODO ...
--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

More detail ... TODO

See also ... TODO

Example:

echo filename | $cmd

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $rePos = qr{[0-9]+([0-9,]*\.?[0-9,]+)?}xms; # positive 0 0.1 1,000.000,000,000
my $isFraction = qr{($rePos/$rePos)};
my $isReciprocal = qr{($rePos/)};

my $notNumber = '(?:\A|[^0-9]|\z)';
my $notLetter = '(?:\A|[^a-zA-Z]|\z)';

# also spaces, all letters needed to spell out symbols
my $subScriptChars   = '.+-*=()<>';
my $superScriptChars = '0123456789.+-*=()<>abcdefgghiIjklmnNoprstuUvwxyz';

my %SubScriptMap = qw(
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
);

my %SuperScriptMap = qw(
);

# GAMMASC - etc SMALL CAPS
my %GreekSmCap = qw(
	GAMMASC     1D26
	LAMDASC     1D27
	PISC        1D28
	RHOSC       1D29
	PSISC       1D2A
);

my %GreekDblStk = qw(
	gamma       213D
	pi          213C
	GAMMA       213E
	PI          213F
	SIGMA       2140
);

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

my @Replacements = ();
my %Replacements = ();

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

sub byLength
{
	return length($b) - length($a);
}

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
	}
}

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

			debug("search: $search rep: $type U+$code");
			if ($type eq 'sy')
			{
				$line = sy($line, $search, $code);
			}
			elsif ($type eq 'syw')
			{
				$line = syw($line, $search, $code);
			}
			elsif ($type eq 'ww')
			{
				$line = ww($line, $search, $code);
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
		}
	}
	debug("line out: $line");
	return $line;
}

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
	if ($match !~ m{\s}xms && !$code)
	{
		warn qq{WARN: $context, No unicode replacement configured for '$match', will not replace.};
	}
	return $code ? U($code) : $match;
}

# translate a matched string to the unicode character from a hash map.
sub translate
{
	my ($match, $escape, $rhSymbolMap) = @ARG;

	my $context = qq{In bracketed sequence $escape\[...\]};
	print qq{TRANS: $match\n};
	# Need to match only at start of string from longest to shortest removing
	# matches as we go, warning about non-matches
	#while ()
	#{
	#}
	my @Tokens = reverse(split(/\b|(?=\d)/, $match));
	print STDERR Dumper(\@Tokens);
	#die "STOPPING";
	$match = join('', map { lookup($ARG, $rhSymbolMap, $context) } @Tokens);

	#if (!exists($rhSymbolMap->{__order}))
	#{
	#	my @Keys = sort byLength keys(%$rhSymbolMap);
	#	$rhSymbolMap->{__order} = \@Keys;
	#}
	#print STDERR Dumper($rhSymbolMap->{__order});
	#foreach my $search (@{$rhSymbolMap->{__order}})
	#{
	#	next if $search eq '__order';
	#	my $literal = quotemeta($search);
	#	$match =~ s{($literal)}{lookup($1, $rhSymbolMap, $context)}xmsge;
	#}
	return $match;
}

# replace square bracketed runs of text ie. _[(n+1)(n-1)]
sub sb
{
	my ($line, $escape, $chars, $rhSymbolMap, $enabled) = @ARG;
	if ($enabled)
	{
		my $esc = quotemeta($escape . '[');
		my $literal = quotemeta($chars);
		# print qq{SB: $esc([0-9a-z$literal])\]\n};
		$line =~ s{$esc([\s0-9a-z$literal]+)\]}{translate($1, $escape, $rhSymbolMap)}xmsge;
	}
	return $line;
}

# replace a literal symbol ie. _s
sub sy
{
	my ($line, $literal, $code) = @ARG;
	$literal = quotemeta(checkLength($literal));
	$line =~ s{$literal}{U($code)}xmsge;
	return $line;
}

# replace a literal full word ie. @theta
sub ww
{
	my ($line, $literal, $code) = @ARG;
	$literal = quotemeta(checkLength($literal));
	$line =~ s{($notLetter)$literal($notLetter)}{$1 . U($code) . $2}xmsge;
	return $line;
}

# replace a literal word symbol ie. _theta
sub syw
{
	my ($line, $literal, $code) = @ARG;
	$literal = quotemeta(checkLength($literal));
	$line =~ s{$literal($notLetter)}{U($code) . $1}xmsge;
	return $line;
}

# replace a fraction if it matches the literal value. ie. 1/3
sub replaceFraction
{
	my ($fraction, $literal, $code) = @ARG;
	debug("replaceFraction?($fraction eq $literal => U+$code)");
	return ($fraction eq $literal) ? yes(U($code)) : $fraction;

}

# replace a literal surrounded by non-numbers ie. 1/3
# First match a literal fraction before making the substitution...
sub nn
{
	my ($line, $literal, $code) = @ARG;
	$literal = checkLength($literal);
	debug("nn($literal => U+$code): line: $line");
	$line =~ s{$isFraction}{replaceFraction($1, $literal, $code)}xmsge;
	return $line;
}

# replace a literal preceded by non-number but followed by numbers ie. 1/3000
sub nd
{
	my ($line, $literal, $code) = @ARG;
	$literal = checkLength($literal);
	debug("nd($literal => U+$code): line: $line");
	$line =~ s{$isReciprocal}{replaceFraction($1, $literal, $code)}xmsge;
	return $line;
}

# construct the parser replacements in order of reverse length
sub makeParser
{
	replacer('ww', '@GAMMASC', $GreekSmCap{GAMMASC}, $MARKUP);
	replacer('ww', '@LAMDASC', $GreekSmCap{LAMDASC}, $MARKUP);
	replacer('ww', '@PISC', $GreekSmCap{PISC}, $MARKUP);
	replacer('ww', '@RHOSC', $GreekSmCap{RHOSC}, $MARKUP);
	replacer('ww', '@PSISC', $GreekSmCap{PSISC}, $MARKUP);


	replacer('ww', '@!gamma', $GreekDblStk{gamma}, $MARKUP);
	replacer('ww', '@!GAMMA', $GreekDblStk{GAMMA}, $MARKUP);
	replacer('ww', '@!pi', $GreekDblStk{pi}, $MARKUP);
	replacer('ww', '@!PI', $GreekDblStk{PI}, $MARKUP);
	replacer('ww', '@!SIGMA', $GreekDblStk{SIGMA}, $MARKUP);

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
	replacer('ww', '@finalsigma', $Greek{finalsigma}, $MARKUP);
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
	replacer('ww', '@*finalsigma', $GreekBold{finalsigma}, $MARKUP);
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
	replacer('ww', '@/finalsigma', $GreekItal{finalsigma}, $MARKUP);
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
	replacer('ww', '@*/finalsigma', $GreekBoldItal{finalsigma}, $MARKUP);
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

	# Operators and Equalities:
# MUSTDO HEREIAM fix code and add tests for these literals next...
	replacer('sy', '+-', 'B1',   $LITERAL);
	replacer('sy', '==', '2261', $LITERAL);
	replacer('sy', '~=', '2245', $LITERAL);
	replacer('sy', '<=', '2264', $LITERAL);
	replacer('sy', '>=', '2265', $LITERAL);

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
	$line = sb($line, '_', $subScriptChars, \%SubScriptMap, $MARKUP);
	#$line = sb($line, '^', $superScriptChars, \%SuperScriptMap, $MARKUP);

	$line = replace($line);
	if (0)
	{

		# TODO convert to replacer() calls
		s{3root}{{U+221B}}xmsg;
		s{4root}{{U+221C}}xmsg;
		s{cross}{{U+2A2F}}xmsg;
		s{sqrt}{{U+221A}}xmsg;
		s{del}{{U+1D6C1} }xmsg;
		s{dee}{{U+1D6DB}}xmsg;
		s{int}{{U+222B}}xmsg;
		s{dot}{{U+22C5}}xmsg;
		s{sum}{{U+2211}}xmsg;

	}

	print $line;
}
