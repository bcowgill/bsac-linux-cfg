#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# utf8dbg.pl
# debug some utf8 character as perl sees it.
# WINDEV tool useful on windows development machine

# TODO continue imlementing recipes from the perl unicode cookbook
# http://www.perl.com/pub/2012/05/perlunicook-match-unicode-properties-in-regex.html

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
use Data::Dumper;
use Devel::Peek;
use File::Slurp;
use FindBin;

my $some_char = "\N{U+1D538}";
my $𝔸 = '𝔸'; # U+1D538 literal and var name
my $multi_char = "\N{LATIN CAPITAL LETTER A WITH MACRON AND GRAVE}";

# handled by use open above
#binmode(STDIN,  ":encoding(utf8)"); # -CI
#binmode(STDOUT, ":utf8"); # -CO
#binmode(STDERR, ":utf8"); # -CE

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	my $cmd = $FindBin::Script;

	print << "USAGE";
usage: $cmd utf8 characters

Debug utf8 characters from various sources. Shows an internally set literal,
the UTF8_TEST environment variable, the file utf8-test.txt, the command line
arguments or standard input.

eg.

export UTF8_TEST=`utf8.pl U+1D538`
utf8.pl U+1D538 > utf8-test.txt
utf8.pl U+1D538 | $cmd

$cmd tschüß TSCHÜSS
$cmd Σίσυφος ΣΊΣΥΦΟΣ
$cmd "henry ⅷ" "HENRY Ⅷ"

utf8.pl U+2424 crlf U+0D U+0A   U+240A lf U+0A	U+240D cr U+0D	U+240B vt U+0B  U+240C ff U+0C  | $cmd
utf8.pl 0 U+24EA U+2070 U+7C0   a U+24D0 U+C2 U+1EA9   '&' U+214B U+FE60 U+FF06 | $cmd

USAGE
	exit(0);
}

print "\$ENV{PERL_UNICODE} = @{[$ENV{PERL_UNICODE} || '']}\n   [set D to make all filehandles utf8]\n";
print "STDOUT: unicode output: $some_char  $multi_char   $𝔸  \n";
print STDERR "STDERR: unicode output: $some_char  $multi_char   $𝔸  \n\n";

print "debug internal utf8 literal:\n";
debug($some_char);

print "debug internal utf8 named multi-character:\n";
debug($multi_char);

print "debug \$𝔸  utf8 var name:\n";
debug($𝔸);

print "debug \$ENV{UTF8_TEST}:\n";
debug(decode_utf8($ENV{UTF8_TEST} || ''));

my $file = 'utf8-test.txt';
print "debug file $file:\n";
if (-f $file)
{
	debug(read_file($file, binmode => ':utf8'));
}

if (scalar(@ARGV)) {
	print "debug \@ARGV:\n";
	@ARGV = map { decode_utf8($ARG, 1) } @ARGV;
	foreach my $string (@ARGV) {
		debug($string);
	}

	print "debug case and comparisons:\n";
	if (scalar(@ARGV) >= 2)
	{
		my $base = shift(@ARGV);
		debugCase($base);
		foreach my $check (@ARGV)
		{
			debugCase($check);
			debugCmp($base, $check);
		}
	}
}
else
{
	print "debug STDIN:\n";
	while (my $line = <STDIN>)
	{
		debug($line);
	}
}

sub debug
{
	my $string = $ARG[0];

	my $vec = toCodeVector($string);
	my $unbroken = normalizeNewlines($string);

	print("\n[ $string ]: $vec\n");
	print("[ $unbroken ]: newline normalized\n");
	print("   is_utf8? ", utf8::is_utf8($string) ? 1: 0, "\n");
	checkLineBreaks($string);
	checkNormalization($string);

	my @chars = split('', $string);
	foreach my $char (@chars)
	{
		debugChar($char);
		Dump($char);
	}
	print "\n";
}

sub normalizeNewlines
{
	my ($string) = @ARG;
	$string =~ s{\R}{\n}xmsg;  # normalize all linebreaks to \n
	return $string;
}

sub debugCase
{
	my $string = $ARG[0];
	print "\n[ $string  ] ucfirst/uc/lc/fc " . ucfirst($string) . "  / " . uc($string) . "  / " . lc($string) . "  / " . fc($string) . "\n";
}

sub debugCmp
{
	my ($base, $check) = @ARG;
	print "   $base  =~ / $check  /i ? " . (($base =~ m{$check}i) ? 1: 0) . "\n";
	print "   $base  eq $check  ? " . (($base eq $check) ? 1: 0) . "\n";
	print "   $base  cmp $check  ? " . ($base cmp $check) . "\n";
	print "   fc( $base  ) eq fc( $check  ) ? " . ((fc($base) eq fc($check)) ? 1: 0) . " - unicode fold case\n";
	print "   fc( $base  ) cmp fc( $check  ) ? " . (fc($base) cmp fc($check)) . " - unicode fold case\n";
}

sub checkLineBreaks
{
	my ($string) = @ARG;
	print "   has \\n? " . (($string =~ m{\n}xmsg) ? 1 : 0) . " - local OS newline\n";
	print "   has \\R? " . (($string =~ m{\R}xmsg) ? 1 : 0) . " - any unicode newline\n";
	print "   has \\v? " . (($string =~ m{\v}xmsg) ? 1 : 0) . " - any vertical feed\n";
}

sub checkCharClasses
{
	my ($char) = @ARG;
	# use v5.14;
	# use re "/a";
#use v5.14;  # needed for regex /a option
#use re "/a"; # to allow /a option on regex to match only ASCII \d \w chars
# http://www.perl.com/pub/2012/05/perlunicook-disable-unicode-awareness-in-builtin-character-classes.html
	print "   has \\d? " . (($char =~ m{\d}xmsg) ? 1 : 0) . " - any unicode digit\n";

	# /a optons not working here what is wrong???
	print "   has /\\d/a ? " . (($char =~ m{\d}axmsg) ? 1 : 0) . " - ASCII digit only\n";
	print "   has [0-9] ? " . (($char =~ m{[0-9]}xmsg) ? 1 : 0) . " - [0-9] digit only\n";
	print "   has \\w ? " . (($char =~ m{\w}xmsg) ? 1 : 0) . " - any unicode word char\n";
	print "   has /\\w/a ? " . (($char =~ m{\w}axmsg) ? 1 : 0) . " - ASCII word char only\n";
	print "   has [a-zA-Z0-9_] ? " . (($char =~ m{[a-zA-Z0-9_]}xmsg) ? 1 : 0) . " - [a-zA-Z0-9_] word char only\n";

}

sub checkUnicodeProperties
{
	my ($char) = @ARG;

	map { testUnicodeProp($char, $ARG) } qw(Space Letter Number Punct Upper Lower Alpha Latin Greek);
	testUnicodeProp($char, 'Numeric_Value=1');
	testUnicodeProp($char, 'Line_Break=Hyphen');
}


# http://www.perl.com/pub/2012/05/perlunicook-match-unicode-properties-in-regex.html
# http://perldoc.perl.org/perlunicode.html#Unicode-Character-Properties
sub testUnicodeProp
{
	my ($char, $name) = @ARG;
	print "   is $name " . (($char =~ m{\p{$name}}xmsg) ? 1 : 0) . " \\p{$name}\n";
	print "   is not $name " . (($char =~ m{\P{$name}}xmsg) ? 1 : 0) . " \\P{$name}\n";
}

sub checkNormalization
{
	my ($string) = @ARG;
	foreach my $form (qw(NFC NFD NFKC NFKD FCC FCD))
	{
		print("   " . checkNormal($form, $string));
	}
}

sub checkNormal
{
	my ($form, $string) = @ARG;
	my $result = check($form, $string);
	if (defined $result)
	{
		$result = $result ? 'YES' : 'NO';
	}
	else
	{
		$result = 'MAYBE(undef)';
	}
	return "is $form normalized? $result\n";
}

sub debugChar
{
	my ($char) = @ARG;
	print("   [ $char ]: @{[debugCodePoint($char)]} bytes[@{[toBytes($char)]}] @{[toName($char)]} @{[toCategory($char)]}\n");
	checkCharClasses($char);
	checkUnicodeProperties($char);
	checkLineBreaks($char);
}

# Show string of code points
# U+NNN.NNN.NNN
sub toCodeVector
{
	my ($string) = @ARG;
	return sprintf("U+%v04X", $string)
}

sub debugCodePoint
{
	my $val = unpack("W", $ARG[0]);
	return $val > 128   ## if wide character...
		? toCodePoint($val) . " $val(d)"   ## {U+....}
		: "$val(d)";   ## return as is
}

sub toCodePoint
{
	my $val = unpack("W", $ARG[0]);
	return sprintf("U+%04X", $val);   ## {U+....}
}

sub toBytes
{
	return join(" ", unpack("U0(H2)*", $ARG[0]));
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
		my $category = charinfo(toCodePoint($char))->{category};  # "Lu"
		$fullCategory = "[$category]";
		$fullCategory = "[$rhCategories->{ $category }]"; # "UppercaseLetter"
	};
	if ($EVAL_ERROR)
	{
		print "ERROR: $EVAL_ERROR";
	}
	return $fullCategory;
}

sub toName
{
	my $val = unpack("W", $ARG[0]);
	my $named = charnames::viacode($val) || "UN-NAMED[@{[toCodePoint($ARG[0])]}]";
	return "\\N{$named}";
}
