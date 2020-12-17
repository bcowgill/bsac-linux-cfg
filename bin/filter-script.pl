#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
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
use FindBin;

my $DEBUG = 0;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Filter the output of the script command to remove ANSI color control codes etc.

--debug shows counts of unicode character classes for each line.
--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Handles ANSI terminal codes, backspaces, terminal alarm bell, some specifics of the elixir iex console.

See also script, pee.pl, filter-whitespace.pl, filter-man.pl

Example:

	script script.log
	$FindBin::Script < script.log
USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--debug}xms)
{
	$DEBUG = 1;
}

# Filter out ANSI color change control sequences
my $esc = "\N{U+001B}"; # ^[ = escape
my $ctrlg = "\N{U+0007}" ; # ^G = bell
my $bs = "\N{U+0008}"; # ^H = backspace
my $exfn = qr{\b\w+[\?\!]?(?:/\d+)?}xms;

while (my $line = <>) {
	$line = NFD($line);   # decompose + reorder canonically
	chomp($line);

	debugUTF8($line) if $DEBUG;

	# cursor jumping on the prompt
	$line =~ s{$esc\]0; (.+) $ctrlg .+ $esc\[00m}{$1}xmsg;
	# ANSI control sequences for color
	$line =~ s{$esc\[\d+m}{}xmsg;
	$line =~ s{$esc\[\d+;\d+m}{}xmsg;
	$line =~ s{$esc\[C}{}xmsg;
	$line =~ s{$esc\]0;}{\n}xmsg;
	$line =~ s{$esc\[\d*K}{}xmsg;
	$line =~ s{$esc\[\d+A}{}xmsg;
	$line =~ s{$ctrlg+}{}xmsg;
	# handle backspacing by deleting character
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

__END__
