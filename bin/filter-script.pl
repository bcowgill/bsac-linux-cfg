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

sub usage
{
	my ($code) = @ARG;
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?] [--debug] [--codes] [file-name...]

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

Create a script log from your console session and then filter it.

	script script.log
	$cmd < script.log

Filter through an elixir script session.

    $cmd elixir/spawn/iex.session.workshare.clean

USAGE
	exit($code || 0);
}

while (scalar(@ARGV) && $ARGV[0] =~ m{\A-}xms)
{
	if ($ARGV[0] =~ m{--help|--man|-\?}xms)
	{
		usage();
	}
	elsif ($ARGV[0] =~ m{--debug}xms)
	{
		$DEBUG = 1;
		shift;
	}
	elsif ($ARGV[0] =~ m{--codes}xms)
	{
		$SHOW_CODES = 1;
		shift;
	}
	elsif ($ARGV[0] =~ m{--}xms)
	{
		print "Invalid option '$ARGV[0]'\n\n";
		usage(1);
	}
}

# Filter out ANSI color change control sequences
my $esc = "\N{U+001B}"; # ^[ = escape
my $bel = "\N{U+0007}"; # ^G = bell
my $bs = "\N{U+0008}"; # ^H = backspace
# esc[ or \x9B = CSI - Control Sequence Introducer
# esc] or \x9D = OSC - Operating System Command
# escP or \x90 = DCS - Device Control String
my $csi = qr/(?:$esc\[|\N{U+009B})/;
my $osc = qr/(?:$esc\]|\N{U+009D})/;
my $dcs = qr/(?:${esc}P|\N{U+0090})/;

# elixir function function/32 function?/12 function!/56
my $exfn = qr{\b\w+[\?\!]?(?:/\d+)?}xms;

sub show_line
{
	my ($line) = @ARG;
	my $orig = $line;
   $line =~	s{\N{U+0008}}{<BS>}xmsg;
	$line =~	s{\N{U+001b}}{ ESC }xmsg;
	$line =~ s{\N{U+0000}}{<NUL>}xmsg;
	$line =~ s{\N{U+0001}}{<SOH>}xmsg;
	$line =~ s{\N{U+0002}}{<STX>}xmsg;
	$line =~ s{\N{U+0003}}{<ETX>}xmsg;
	$line =~ s{\N{U+0004}}{<EOT>}xmsg;
	$line =~ s{\N{U+0005}}{<ENQ>}xmsg;
	$line =~ s{\N{U+0006}}{<ACK>}xmsg;
	$line =~	s{\N{U+0007}}{<BEL>}xmsg;
	$line =~ s{\N{U+0008}}{<BS>}xmsg;
	$line =~ s{\N{U+0009}}{<HT>}xmsg;
	$line =~ s{\N{U+000b}}{<VT>}xmsg;
	$line =~ s{\N{U+000c}}{<FF>}xmsg;
	$line =~ s{\N{U+000e}}{<SO>}xmsg;
	$line =~ s{\N{U+000f}}{<SI>}xmsg;
	$line =~ s{\N{U+0010}}{<DLE>}xmsg;
	$line =~ s{\N{U+0011}}{<DC1>}xmsg;
	$line =~ s{\N{U+0012}}{<DC2>}xmsg;
	$line =~ s{\N{U+0013}}{<DC3>}xmsg;
	$line =~ s{\N{U+0014}}{<DC4>}xmsg;
	$line =~ s{\N{U+0015}}{<NAK>}xmsg;
	$line =~ s{\N{U+0016}}{<SYN>}xmsg;
	$line =~ s{\N{U+0017}}{<ETB>}xmsg;
	$line =~ s{\N{U+0018}}{<CAN>}xmsg;
	$line =~ s{\N{U+0019}}{<EM>}xmsg;
	$line =~ s{\N{U+001a}}{<SUB>}xmsg;
	$line =~ s{\N{U+001b}}{<ESC>}xmsg;
	$line =~ s{\N{U+001c}}{<FS>}xmsg;
	$line =~ s{\N{U+001d}}{<GS>}xmsg;
	$line =~ s{\N{U+001e}}{<RS>}xmsg;
	$line =~ s{\N{U+001f}}{<US>}xmsg;
	$line =~ s{\N{U+007f}}{<DEL>}xmsg;

	$line =~	s{\N{U+009b}}{<CSI>}xmsg;
	$line =~	s{\N{U+009d}}{<OSC>}xmsg;
	$line =~	s{\N{U+0090}}{<DCS>}xmsg;

	if ($orig ne $line)
	{
		$line =~ s{\x0d\x0a}{ <CR><LF>}xmsg;
		$line =~ s{\x0d}{ <CR>}xmsg;
		$line =~ s{\x0a}{ <LF>}xmsg;
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

my $is_iex_log = 0;
my $is_iex_listing = 0;

while (my $line = <>) {
	$line = NFD($line);   # decompose + reorder canonically
	chomp($line);

	debugUTF8($line) if $DEBUG;

	# bs ESC[K = bs
	$line =~ s{$bs${csi}K}{$bs}xmsge;

	# cursor jumping on the prompt (ansi1,ansi8 test)
	$line =~ s{${osc}0; (.+) $bel .+ ${csi}00m}{\n$1}xmsg;
	$line =~ s{${osc}0;}{\n}xmsg;

	$line =~ s{$bel+}{}xmsg; # alarm bell must be after prompt fix

	$line =~ s{${csi}[0-9;]*[ABCDEFfGHru]}{\n}xmsg; # cursor move up/down etc (ansi1 test)
	# color change, etc just remove totally
	$line =~ s{${csi}=\d*[hl]}{}xmsg; # set/reset screen width/type (ansi3 test)
	$line =~ s{${csi}\?\d+[hl]}{}xmsg; # private modes invisible etc (ansi4 test)

	$line =~ s{${csi}\d*[JK]\r?}{\n}xmsg; # erase screen, line, etc
	$line =~ s{${csi}[0-9;]*[JKmnPps]}{}xmsg; # erase screen, line, set graphics modes, set bold/dim/italic, etc (ansi2,ansi5,ansi7 test)
	$line =~ s{(${csi}[0-9;]+"[^"]*";p)}{}xmsg; # (ansi6 test)

	$line =~ s{${esc}M}{\n}xmsg; # move cursor up one line/scroll (ansi9 test)
	if ($DEC)
	{
		$line =~ s{${esc}7}{}xmsg; # save cursor position (ansi9 test)
		$line =~ s{${esc}8}{\n}xmsg; # restore saved cursor position (ansi9 test)
	}
	# handle backspacing by deleting character
	while ($line =~ s{[^$bs] $bs}{}xmsg) {}

	# in-place progress bars, omit intermediate states
	# 141.4 MiB [=================== ] 92% 1.0s
	$line =~ s{([\d.]+\s+MiB\s+\[[\s=]+\]\s+(\d+)\%\s+[\d.]+s)(\s+)}{($2 eq '0' || $2 eq '100') ? "$1$3": "" }xmsge;

	# (⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂) ⠧ idealTree:playwright: sill idealTree buildDeps
	$line =~ s{(\(([⠂\#]+)\)\s+[^\n]+)\n}{($2 eq ('⠂' x 18) || $2 eq ('#' x 18)) ? "$1\n": ""}xmsge;


	# iex prompt remove numbers
	$is_iex_log++ if $is_iex_log;
	if ($line =~ s{\A iex \(\d+\)>}{\niex(n)>}xmsg)
	{
		$is_iex_log = 1;
	} elsif ($line =~ m{\A\s*\z}xms)
	{
		$is_iex_log = 0;
		$is_iex_listing = 0;
	}
	if ($is_iex_log)
	{

		# iex list of functions
		my $save = $is_iex_listing;
		$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{\t$1\n\t$2\n\t$3\n\t$4\n\t$5\n}xmsg and $is_iex_listing++;
		$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{\t$1\n\t$2\n\t$3\n\t$4\n}xmsg and $is_iex_listing++;
		$line =~ s{\A ($exfn) \s+ ($exfn) \s+ ($exfn) \s* \z}{\t$1\n\t$2\n\t$3\n}xmsg and $is_iex_listing++;
		$line =~ s{\A ($exfn) \s+ ($exfn) \s* \z}{\t$1\n\t$2\n}xmsg and $is_iex_listing++;
		#print ">>>1 save:$save  is list: $is_iex_listing is log: $is_iex_log $line\n" if $line =~ m{Term|Data|Type}xms;
		if ($save && $save == $is_iex_listing)
		{
			#print ">>>2 save:$save  is list: $is_iex_listing is log: $is_iex_log $line\n" if $line =~ m{Term|Data|Type}xms;
			$line =~ s{\A ($exfn) \s* \z}{\t$1\n}xmsg and $is_iex_listing = 0;
			#print ">>>3 save:$save  is list: $is_iex_listing is log: $is_iex_log $line\n" if $line =~ m{Term|Data|Type}xms;
		}
		else
		{
			#print ">>>4 save:$save  is list: $is_iex_listing is log: $is_iex_log $line\n" if $line =~ m{Term|Data|Type}xms;
			$is_iex_listing = $save || $is_iex_listing;
		}
		if ($is_iex_log > 1 && !$is_iex_listing)
		{
			$is_iex_log = 0;
		}
		#print ">>>5 save:$save  is list: $is_iex_listing is log: $is_iex_log $line\n" if $line =~ m{Term|Data|Type}xms;
	} # $is_iex_log

	$line =~ s{\A:\x0d}{\n}xmsg; # pager line from less
	$line =~ s{\x0d}{\n}xmsg; # CR by itself convert to newline
	$line =~ s{\s+\z}{}xms;
	$line =~ s{\n\n\n+}{\n\n\n}xmsg;

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
