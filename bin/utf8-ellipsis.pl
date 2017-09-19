#!/usr/bin/env perl
# replace ... ellipsis with actual unicode ellipsis

# http://www.perl.com/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html

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
my $ellipsis = "\N{U+2026}";

while (my $line = <>) {
	$line = NFD($line);   # decompose + reorder canonically
	chomp($line);

	#debugUTF8($line);
	$line =~ s{\.\.\.}{$ellipsis}xmsg;
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

#  LocalWords:  xdigit
