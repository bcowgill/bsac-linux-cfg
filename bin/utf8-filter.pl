#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# sample unicode-savvy filter - unicode search and replace tool sample
# http://www.perl.com/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html
# WINDEV tool useful on windows development machine
# See also utf8tr.pl, math-rep.pl, utf8-ellipsis.pl, anglicise.pl, utf8ls-letter.sh, utf8ls-number.sh, utf8ls.pl

use English qw(-no_match_vars);
use utf8;      # so literals and identifiers can be in UTF-8
use v5.12;     # or later to get "unicode_strings" feature
use strict;    # quote strings, declare variables
use warnings;  # on by default
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use charnames qw(:full :short);  # unneeded in v5.16
use Unicode::Normalize; # to check normalisation

# Filter out leading space/invisible space pasted from e-book
my $some_char = "\N{U+200B}";

while (my $line = <>) {
	$line = NFD($line);   # decompose + reorder canonically
	chomp($line);

	#debugUTF8($line);
	$line =~ s{$some_char}{}xmsg;
	$line =~ s{\A\ \t}{}xms;
	$line =~ s{\A(\-|»|\d+:)\ ?\t}{}xmsg;
	$line =~ s{\s+\z}{}xms;

	$line .= "\n";
} continue {
	print NFC($line);  # recompose (where possible) + reorder canonically
}

sub debugUTF8 {
	my ($canonical) = @ARG;

	# http://www.regular-expressions.info/posixbrackets.html
	foreach my $class ( qw(alnum alpha ascii blank cntrl digit graph lower
		print punct space upper word xdigit ) )
	{
		print "line below matches [[:$class:]] ? " . (($canonical =~ m{[[:$class:]]}xms) ? 1: 0) . "\n";
	}
}
