#!/usr/bin/env perl
# filter the output of the script command to remove color control codes etc
# WINDEV tool useful on windows development machine

use English qw(-no_match_vars);
use utf8;      # so literals and identifiers can be in UTF-8
use v5.12;     # or later to get "unicode_strings" feature
use strict;    # quote strings, declare variables
use warnings;  # on by default
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use charnames qw(:full :short);  # unneeded in v5.16
use Unicode::Normalize; # to check normalisation

# Filter out ANSI color change control sequences
my $esc = "\N{U+001B}"; # ^[ = escape
my $ctrlg = "\N{U+0007}" ; # ^G = tab
my $bs = "\N{U+0008}"; # ^H = backspace
my $exfn = qr{\b\w+[\?\!]?(?:/\d+)?}xms;

while (my $line = <>) {
	$line = NFD($line);   # decompose + reorder canonically
	chomp($line);

	#debugUTF8($line);

	# cursor jumping on the prompt
	$line =~ s{$esc\]0; (.+) $ctrlg .+ $esc\[00m}{$1}xmsg;
	# ANSI control sequences for color
	$line =~ s{$esc\[\d+m}{}xmsg;
	$line =~ s{$esc\[\d+;\d+m}{}xmsg;
	$line =~ s{$esc\[C}{}xmsg;
	$line =~ s{$esc\]0;}{\n}xmsg;
	$line =~ s{$esc\[\d*K}{}xmsg;
	$line =~ s{$esc\[\d+A}{}xmsg;
	# handle backspacing by deleting character
	$line =~ s{$ctrlg+}{}xmsg;
	while ($line =~ s{[^$bs] $bs}{}xmsg) {}

	# iex prompt remove numbers
	$line =~ s{\A iex \(\d+\)>}{\niex(n)>}xmsg;
	# iex list of functions
	$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n$3\n$4\n$5\n}xmsg;
	$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n$3\n$4\n}xmsg;
	$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n$3\n}xmsg;
	$line =~ s{\A ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n}xmsg;

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
