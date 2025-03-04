#!/usr/bin/env perl
# Convert NBSP characters to spaces when pasting JS transpiled code from https://www.typescriptlang.org
# based on ~/bin/tx.pl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use utf8;	  # so literals and identifiers can be in UTF-8
use v5.16;	 # or later to get "unicode_strings" feature
use strict;	# quote strings, declare variables
use warnings;  # on by default
use warnings  qw(FATAL utf8);	# fatalize encoding glitches
use open	  qw(:std :utf8);	# undeclared streams in UTF-8
use Unicode::UCD qw( charinfo general_categories );  # to get category of character
use Unicode::Normalize qw(check); # to check normalisation
use Encode qw(decode_utf8); # to convert args/env vars

use English qw(-no_match_vars);
use Data::Dumper;
use Devel::Peek;
use File::Slurp;
use FindBin;

my $NBSP = "\N{U+00A0}"; # Define Unicode code point for use in regex

# Verify you got the right unicode character!
#print STDERR "[$NBSP]\n";

while (my $line = <>)
{
	$line =~ s[$NBSP][ ]xmsg;
	#$line =~ s[\N{0031}][@]xmsg; # replaces 31 characters with @
	#$line =~ s[\N{NO-BREAK SPACE}][@]xmsg; # search/replace with exact unicode char name
	#$line =~ s[ ][@]xmsg; # search/replace with hard coded unicode char NBSP
	#$line =~ tr[ ][@]; # hard coded unicode char in translation list
	print $line;
}
