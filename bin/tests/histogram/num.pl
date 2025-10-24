#!/usr/bin/perl
use strict;
use warnings;
use English;

my $HIDE = 0;
my $DEBUG = 0;

while (my $line = <>)
{
	chomp($line);
	if ($line =~ m{(U\+[\dA-F]+).+\b(GREEK(?:\ ZERO)?|DIGIT|NUMBER|NUMERAL|IDEOGRAPH|NUMERIC\ SIGN|BAMUM|GOTHIC\ LETTER|ATTIC|ANNOTATION|THESPIAN|HERAEUM|HERMIONIAN|EPIDAUREAN|CYRENAIC|TROEZENIAN|MESSENIAN|CARYSTIAN|NAXIAN|DELPHIC|STRATIAN|ATTAK|RUNIC|FRACTION|CURRENCY)\s+(.+)\z}xms)
	{
		my ($codept, $type, $value) = ($1, $2, $3);

		# https://blog.plover.com/math/telugu.html
		#1 TELUGU FRACTION DIGIT ONE FOR ODD POWERS OF FOUR
		#4 TELUGU FRACTION DIGIT ONE FOR EVEN POWERS OF FOUR
		$value =~ s{\ for\ (odd|even)\ powers\ of\ (4|four)}{}xmsi;

		#3/4 BENGALI CURRENCY NUMERATOR ONE LESS THAN THE DENOMINATOR
		#/16 BENGALI CURRENCY DENOMINATOR SIXTEEN
		$value =~ s{numerator\ one\ less\ than\ the\ denominator}{3/4}xmsi;
		$value =~ s{denominator\ sixteen}{/16}xmsi;

		if ($type eq 'GREEK ZERO') {
			$value = 0;
		}
		elsif ($value =~ s{\ thousand\ talents?}{}xmsi)
		{
			$value = numbers($value, ',000,000');
		}
		elsif ($value =~ s{\ hundred\ (thousand|talents?)}{}xmsi)
		{
			$value = numbers($value, '00,000');
		}
		elsif ($value =~ s{\ (thousand|talents?)}{}xmsi)
		{
			$value = numbers($value, ',000');
		}
		elsif ($value =~ s{\ (hundred|plethron)}{}xmsi)
		{
			$value = numbers($value, '00');
		}
		$value = numbers($value);

		$value =~ s{([234])0\ (\d)\b}{$1$2}xms;
		$value =~ s{\ on\ black\ square}{}xmsi;
		$value =~ s{\ (early|late|variant|alternate)\ form(\ a)}{}xmsi;
		$value =~ s{\ full\ stop}{.}xmsi;
		$value =~ s{\ comma}{,}xmsi;
		$value =~ s{old\ assyrian\ }{}xmsi;
		$value =~ s{\ c\ d}{}xmsi;
		$value =~ s{\ sign(\ alternate\ form)?}{}xmsi;
		$value =~ s{\ (mark|dish|buru|(shar|gesh)[2u]|esh16|esh21|eshe3|ban2|ash\ tenu|ash9?|(limmu|ilimmu|ussu|imin)([34]|\ [ab])?|u)\b}{}xmsi;
		$value =~ s{\ mnas\b}{ minas}xmsi;
		$value =~ s{\ (drachmas?)\b}{' ' . lc($1)}xmsie;
		$value =~ s{\ (staters?)\b}{×5,000}xmsi;
		$value =~ s{numerator\ (\d+)}{$1/}xmsi;

		if ($value =~ m{\A-?[\(\d,./\)]+\z}xms)
		{
			$value = "($value)" if ($line =~ m{\s((NEGATIVE\ )?CIRCLED|PARENTHESIZED)}xms);
			show($value, $codept) unless $HIDE;
		}
		else
		{
			#$value =~ s{\A\d+(,\d+)?\s}{}xms;
			#print "$value -- $line\n";
			print "$value#\\N{$codept} -- $line\n" if $DEBUG;
			show($value, $codept);
		}
	}
	else
	{
		print "UNKNOWN >>$line\n" unless $line =~ m{===|\A\s*\z}xms;
	}
}

sub show
{
	my($value, $codept) = @ARG;
	$value = "$value " if (length($value) > 1);
	print "$value#\\N{$codept}\n";
}

sub numbers
{
	my ($value, $append) = @ARG;
	my $BL = "letter";

	$append = $append || '';
	$value =~ s{SHAR2\ TIMES\ GAL\ PLUS\ DISH}{216,000}xmsi;
	$value =~ s{SHAR2\ TIMES\ GAL\ PLUS\ MIN}{432,000}xmsi;
	$value =~ s{NIGIDAMIN}{2}xmsi;
	$value =~ s{NIGIDAESH}{3}xmsi;
	#-1 TIBETAN DIGIT HALF ZERO
	$value =~ s{half\ three}{5/2}xmsi;
	$value =~ s{half\ zero}{-1}xmsi;
	$value =~ s{half\ four}{7/2}xmsi;
	$value =~ s{half\ five}{9/2}xmsi;
	$value =~ s{half\ seven}{13/2}xmsi;
	$value =~ s{half\ eight}{15/2}xmsi;
	$value =~ s{half\ nine}{17/2}xmsi;
	$value =~ s{half\ six}{11/2}xmsi;
	$value =~ s{half\ one}{1/2}xmsi;
	$value =~ s{half\ two}{3/2}xmsi;
	$value =~ s{\ sixteenths?\b}{/16}xmsi;
	$value =~ s{\ quarters?\b}{/4}xmsi;
	$value =~ s{\ sevenths?\b}{/7}xmsi;
	$value =~ s{\ eighths?\b}{/8}xmsi;
	$value =~ s{\ tenths?\b}{/10}xmsi;
	$value =~ s{\ ninths?\b}{/9}xmsi;
	$value =~ s{\ thirds?\b}{/3}xmsi;
	$value =~ s{\ fifths?\b}{/5}xmsi;
	$value =~ s{\ sixths?\b}{/6}xmsi;
	$value =~ s{\ half\b}{/2}xmsi;
	$value =~ s{\b(seventeen|arlaug\ symbol)\b}{17$append}xmsi;
	$value =~ s{\b(nineteen|belgthor\ symbol)\b}{19$append}xmsi;
	$value =~ s{\b(eighteen|tvimadur\ symbol)\b}{18$append}xmsi;
	$value =~ s{\bfourteen\b}{14$append}xmsi;
	$value =~ s{\bthirteen\b}{13$append}xmsi;
	$value =~ s{\bhundred\b}{100$append}xmsi;
	$value =~ s{\bseventy\b}{70$append}xmsi;
	$value =~ s{\bsixteen\b}{16$append}xmsi;
	$value =~ s{\bfifteen\b}{15$append}xmsi;
	$value =~ s{\bninety\b}{90$append}xmsi;
	$value =~ s{\beighty\b}{80$append}xmsi;
	$value =~ s{\bthirty\b}{30$append}xmsi;
	$value =~ s{\btwenty\b}{20$append}xmsi;
	$value =~ s{\btwelve\b}{12$append}xmsi;
	$value =~ s{\beleven\b}{11$append}xmsi;
	$value =~ s{\bsixty\b}{60$append}xmsi;
	$value =~ s{\bforty\b}{40$append}xmsi;
	$value =~ s{\b(eight|pram-pii|$BL\ faamae)\b}{8$append}xmsi;
	$value =~ s{\b(seven|pram-muoy|$BL\ samba)\b}{7$append}xmsi;
	$value =~ s{\bfifty\b}{50$append}xmsi;
	$value =~ s{\b(three|pii|$BL\ tet)\b}{3$append}xmsi;
	$value =~ s{\b(nine|pram-(bei|buon)|$BL\ kovuu)\b}{9$append}xmsi;
	$value =~ s{\b(five|buon|$BL\ ten)\b}{5$append}xmsi;
	$value =~ s{\b(four|bei|$BL\ kpa)\b}{4$append}xmsi;
	$value =~ s{\bzero\b}{0$append}xmsi;
	$value =~ s{\b(ten|$BL\ koghom)\b}{10$append}xmsi;
	$value =~ s{\b(six|pram|$BL\ ntuu)\b}{6$append}xmsi;
	$value =~ s{\b(two|muoy|$BL\ mbaa)\b}{2$append}xmsi;
	$value =~ s{\b(one|son|$BL\ mo)\b}{1$append}xmsi;

	return $value;
}
