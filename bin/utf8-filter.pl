#!/usr/bin/env perl
# sample unicode-savvy filter
# http://www.perl.com/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html

use utf8;      # so literals and identifiers can be in UTF-8
use v5.12;     # or later to get "unicode_strings" feature
use strict;    # quote strings, declare variables
use warnings;  # on by default
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use charnames qw(:full :short);  # unneeded in v5.16
use Unicode::Normalize; # to check normalisation

while (<>) {
    $_ = NFD($_);   # decompose + reorder canonically

    # http://www.regular-expressions.info/posixbrackets.html
    foreach my $class ( qw(alnum alpha ascii blank cntrl digit graph lower print punct space upper word xdigit ) )
    {
        print "matches [[:$class:]] ? " . (($_ =~ m{[[:$class:]]}xms) ? 1: 0) . "\n";
    }
} continue {
    print NFC($_);  # recompose (where possible) + reorder canonically
}
