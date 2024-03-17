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

my $SHOW_CODES = 0;
my $DEBUG = 0;
my $DEC = 1;
my $SCO = 1;

sub usage
{
	my ($code) = @ARG;
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [--debug] [--codes] [file-name...]

Filter the output of the script command to remove ANSI color control codes and other terminal controls.

file-name specifies script log files to filter or standard input if omitted.
--debug   shows counts of unicode character classes for each line.
--codes   shows any remaining control codes left in the line as a '>>>' line on standard error.
--help    shows help for this program.
--man     shows help for this program.
-?        shows help for this program.

Handles ANSI terminal codes, backspaces, terminal alarm bell, some specifics of the elixir iex console, and some common progress bar indicators.

See also script, pee.pl, filter-whitespace.pl, filter-man.pl

See also Everything You Wanted to Know about ANSI Escape Codes: https://notes.burke.libbey.me/ansi-escape-codes/
or ANSI Escape Sequences https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
or XTerm Control Sequences https://invisible-island.net/xterm/ctlseqs/ctlseqs.html

Example:

	script script.log
	$FindBin::Script < script.log
USAGE
	exit($code || 0);
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--debug}xms)
{
	$DEBUG = 1;
	shift;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--codes}xms)
{
	$SHOW_CODES = 1;
	shift;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--}xms)
{
	print "Invalid argument '$ARGV[0]'\n\n";
	usage(1);
}

# Filter out ANSI color change control sequences
my $esc = "\N{U+001B}"; # ^[ = escape
my $ctrlg = "\N{U+0007}" ; # ^G = bell
my $bs = "\N{U+0008}"; # ^H = backspace
my $exfn = qr{\b\w+[\?\!]?(?:/\d+)?}xms;
# esc[ or \x9B = CSI - Control Sequence Introducer
# esc] or \x9D = OSC - Operating System Command
# escP or \x90 = DCS - Device Control String
my $csi = qr/$esc\[|\N{U+009B}/;
my $osc = qr/$esc\]|\N{U+009D}/;
my $dcs = qr/${esc}P|\N{U+0090}/;

sub show_line
{
	my ($line) = @ARG;
	my $orig = $line;
	$line =~	s{\N{U+001b}}{ ESC }xmsg;
	$line =~	s{\N{U+0007}}{ BEL }xmsg;
   $line =~	s{\N{U+0008}}{ BS }xmsg;
	$line =~	s{\N{U+009b}}{ CSI }xmsg;
	$line =~	s{\N{U+009d}}{ OSC }xmsg;
	$line =~	s{\N{U+0090}}{ DCS }xmsg;
	if ($orig ne $line)
	{
		$line =~ s{\x0d\x0a}{ CRLF}xmsg;
		$line =~ s{\x0d}{ CR}xmsg;
		$line =~ s{\x0a}{ LF}xmsg;
		print STDERR ">>> $line\n" if $SHOW_CODES;
	}
}

sub show_codes
{
	my ($all) = @ARG;
	my @Lines = split(/\n/, $all);
	foreach my $line (@Lines) {
		show_line($line)
	}
}

while (my $line = <>) {
	$line = NFD($line);   # decompose + reorder canonically
	chomp($line);

	debugUTF8($line) if $DEBUG;

	# bs ESC[K = bs
	$line =~ s{$bs$esc\[K}{$bs}xmsge;

	# cursor jumping on the prompt
	$line =~ s{$esc\]0; (.+) $ctrlg .+ $esc\[00m}{\n$1}xmsg;
	$line =~ s{$esc\]0;}{\n}xmsg;

	$line =~ s{$esc\[=\d+[hl]}{}xmsg; # set/reset screen width/type
	$line =~ s{$esc\[\?\d+[hl]}{}xmsg; # private modes invisible etc

	$line =~ s{$esc\[\d+[;\d]+m}{}xmsg; # set graphics modes
	$line =~ s{$esc\[\d+m}{}xmsg; # set bold/dim/italic, etc

	$line =~ s{$esc\[6n}{}xmsg; # ask cursor position
	$line =~ s{$esc\[\d+;\d+[Hr]}{\n}xmsg; # cursor to line/col
	$line =~ s{$esc\[[CF]}{}xmsg; # TODO what is it???
	$line =~ s{$esc\[\d+P}{}xmsg; # TODO what is it???
	$line =~ s{$esc\[H}{\n}xmsg; # cursor to home pos
	$line =~ s{$esc\[\d*[JK]\r?}{\n}xmsg; # erase screen, line, etc
	$line =~ s{$esc\[\d+[ABCDEFG]}{\n}xmsg; # cursor move up/down etc
	$line =~ s{$ctrlg+}{}xmsg; # alarm bell
	$line =~ s{$esc\[\?\d+[hl]}{}xmsg; # Set controlling flags high/low
	$line =~ s{${esc}M}{\n}xmsg; # move cursor up one line/scroll
	if ($DEC)
	{
		$line =~ s{${esc}7}{}xmsg; # save cursor position
		$line =~ s{${esc}8}{\n}xmsg; # restore saved cursor position
	}
	if ($SCO)
	{
		$line =~ s{$esc\[s}{}xmsg; # save cursor position
		$line =~ s{$esc\[u}{\n}xmsg; # restore saved cursor position
	}
	# handle backspacing by deleting character
	while ($line =~ s{[^$bs] $bs}{}xmsg) {}

	# in-place progress bars, omit intermediate states
	# 141.4 MiB [=================== ] 92% 1.0s
	$line =~ s{([\d.]+\s+MiB\s+\[[\s=]+\]\s+(\d+)\%\s+[\d.]+s)(\s+)}{($2 eq '0' || $2 eq '100') ? "$1$3": "" }xmsge;

	# (⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂) ⠧ idealTree:playwright: sill idealTree buildDeps
	$line =~ s{(\(([⠂\#]+)\)\s+[^\n]+)\n}{($2 eq ('⠂' x 18) || $2 eq ('#' x 18)) ? "$1\n": ""}xmsge;

	# iex prompt remove numbers
	$line =~ s{\A iex \(\d+\)>}{\niex(n)>}xmsg;
	# iex list of functions
	$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n$3\n$4\n$5\n}xmsg;
	$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n$3\n$4\n}xmsg;
	$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n$3\n}xmsg;
	$line =~ s{\A ($exfn) \s+ ($exfn) \s* \z}{$1\n$2\n}xmsg;

	$line =~ s{\A:\x0d}{\n}xmsg; # pager line from less
	$line =~ s{\x0d}{\n}xmsg; # CR by itself convert to newline
	$line =~ s{\s+\z}{}xms;

	show_codes($line);
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
