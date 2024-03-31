#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
use strict;
use warnings;
use FindBin;
use English qw(-no_match_vars);
use Fatal qw(open);
use POSIX;

my $cmd = $FindBin::Script;

sub usage
{
	my ($message) = @ARG;

	print qq{$message\n\n} if $message;
	print <<"USAGE";
$cmd [--append] [--control] [--help|--man|-?] file_name

Similar to tee but with date and elapsed time, line wrapping and removal of ANSI terminal control characters.

COLUMNS   environment variable specifying what colum to wrap for the log file. default 60. Specify 0 for no wrapping.
UPDATE    specifies to output to stdout only every UPDATE lines. The log file will have everything but the console will have less output.
--append  appends to the named log file instead of overwriting it.
--control shows ANSI ESC control sequences instead of replacing them with whitespace.
--help    shows help for this program.
--man     shows help for this program.
-?        shows help for this program.

This program will print standard input to standard output and clean it up before writing it to the log file.

It will also wrap the output to the current COLUMNS environment setting.

It can reduce the output shown on the console to prevent slowing things down.

See also tee, filter-script.pl, filter-whitespace.pl, filter-man.pl

See also Everything You Wanted to Know about ANSI Escape Codes: https://notes.burke.libbey.me/ansi-escape-codes/
or ANSI Escape Sequences https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
or XTerm Control Sequences https://invisible-island.net/xterm/ctlseqs/ctlseqs.html

Example:

	Run the tests, filter out 0/100 coverage and also log the results to a file.

npm test | filter-coverage.sh | $cmd tests.log

	Find files and log them all, but only print out every 250 to reduce console noise.

find / -type f | UPDATE=250 $cmd files.lst

USAGE
	exit ($message ? 1 : 0);
}

my $MODULUS = $ENV{UPDATE} || 0;
my $SHOW_ESC = 0;

my $esc = qq{\x1b}; # ^[ = escape
my $bel = qq{\x7}; # ^G = bell
my $bs = qq{\x8}; # ^H = backspace
# esc[ or \x9B = CSI - Control Sequence Introducer
# esc] or \x9D = OSC - Operating System Command
# escP or \x90 = DCS - Device Control String
my $csi = qr/(?:$esc\[|\N{U+009B})/;
my $osc = qr/(?:$esc\]|\N{U+009D})/;
my $dcs = qr/(?:${esc}P|\N{U+0090})/;

my $ESC = qq{ ESC};

# Get column wrap width from environment or use default
my $WRAP = $ENV{COLUMNS} eq "0" ? 0 : ($ENV{COLUMNS} || 60);
my $mode = '>';

sub ansi
{
	my($start, $end) = @ARG;
	print qq{ansi $start $end $esc$start$end $esc${start}0$end $esc${start}1;4$end $esc${start}5;9;$end\n};
}

sub output_control_for_test
{
	my $csi = "$esc\[";
	my $osc = "$esc\]";
	print qq{control   \a \b \f \t\n};
	print qq{control2  \x01 \x02 \x03 \x04 \x05 \x06 \x07 \x08 \x09 \x0b \x0c \x0e \x0f \x10 \x11 \x12 \x13 \x14 \x15 \x16 \x17 \x18 \x19 \x1a \x1b \x1c \x1d \x1e \x1f \x7f\n};
#   print qq{control3  \x90 \x9b \x9d\n}; # <= diffmerge cannot handle
	print qq{backspace $bs$bs$bs$bs${csi}K\n};
	print qq{bell      $bel$bel$bel\n};
	print qq{esc       $esc$esc$esc\n};
	print qq{prompt    ${osc}0;prompt text>$bel delete me ${csi}00m\n};
	print qq{ansi1 ${osc}0; ${csi}0A ${csi}B ${csi}0;45;C ${csi}D ${csi}E ${csi}F ${csi}f ${csi}G ${csi}H ${csi}r ${csi}u\n};
	print qq{ansi2 ${csi}J ${csi}0;9;K ${csi}0;9m ${csi}n ${csi}P ${csi}p ${csi}s\n};
	print qq{ansi3 ${csi}=h ${csi}=0;9l\n};
	print qq{ansi4 ${csi}\?h ${csi}\?90h\n};
	print qq{ansi5 ${csi}0;9p ${csi}0p\n};
	print qq{ansi6 ${csi}0;9;"";p ${csi}90"something";p\n};
	print qq{ansi7 ${csi}2J\n};
   print qq{ansi8 ${osc}0;\n};
	print qq{ansi9 ${esc}M ${esc}7 ${esc}8\n};

	print qq{less:\n:\x0d\x0a:\x0a:\n};
	print qq{\n\n};
	exit;
}

while (scalar(@ARGV) && $ARGV[0] =~ m{\A-}xms)
{
	if ($ARGV[0] =~ m{--help|--man|-\?}xms)
	{
		usage();
	}
	elsif ($ARGV[0] eq '--control')
	{
		$SHOW_ESC = 1;
		shift;
	}
	elsif ($ARGV[0] eq '--test')
	{
		output_control_for_test();
	}
	elsif ($ARGV[0] eq '--append')
	{
		$mode = '>>';
		shift;
	}
	else
	{
		usage("unrecognised option '$ARGV[0]'");
	}
} # while

usage("You must provide an output file name.") unless scalar(@ARGV);

my $file = shift;

my $fh;
open($fh, $mode, $file);

# Turn off bufferring so you can tail the output
my $h = select(STDOUT);
$| = 1;
select($h);
$h = select($fh);
$| = 1;
select($h);

sub echo
{
	my ($message, $log) = @ARG;
	$log = $log || $message;
	print qq{$message};
	print $fh qq{$log};
}

sub echo_line
{
	my ($message, $log) = @ARG;
	$log = $log || $message;
	if (!$MODULUS || !($. % $MODULUS)) {
		print qq{$message};
	}
	print $fh qq{$log};
}

sub wrap
{
	my ($line) = @ARG;
	chomp($line);
	my @lines = ();
	while ($WRAP && length($line) > $WRAP)
	{
		my $part = substr($line, 0, $WRAP);
		$line = substr($line, $WRAP);
		if ($line =~ s{\A\s}{}xms)
		{
			push(@lines, $part);
		}
		else
		{
			$line =~ s{\A(\S+)(\s|\z)}{}xms;
			push(@lines, $part . $1);
		}
	}
	push(@lines, $line) if length($line);
	return join("\n", @lines) . "\n";
}

sub plural
{
	my ($number, $string) = @ARG;
	return '' if $number == 0;
	return qq{$number $string} if $number == 1;
	return qq{$number ${string}s};
}

sub duration
{
	my ($elapsed) = @ARG;
	if ($elapsed > 120)
	{
		my $seconds = $elapsed % 60;
		$elapsed = int($elapsed / 60);
		$elapsed = join(' ', (
			plural($elapsed, 'minute'),
			plural($seconds, 'second')
		));
	}
	else
	{
		$elapsed = plural($elapsed, 'second');
	}
}

sub show_esc
{
	my ($codes, $replace) = @ARG;
	$codes =~ s{$esc}{ ESC}xmsg;
	return $SHOW_ESC ? qq{$codes $replace} : $replace;
}

sub clean_ansi
{
	my ($line) = @ARG;

   # MUSTDO See filter-script program and update this...
	# backspace, bell
	if ($SHOW_ESC)
	{
		# See hexdump manual page for control codes
		$line =~ s{$bs}{<BS>}xmsg;
		$line =~ s{$esc}{ ESC}xmsg;
		$line =~ s{\x00}{<NUL>}xmsg;
		$line =~ s{\x01}{<SOH>}xmsg;
		$line =~ s{\x02}{<STX>}xmsg;
		$line =~ s{\x03}{<ETX>}xmsg;
		$line =~ s{\x04}{<EOT>}xmsg;
		$line =~ s{\x05}{<ENQ>}xmsg;
		$line =~ s{\x06}{<ACK>}xmsg;
		$line =~ s{\x07}{<BEL>}xmsg;
		$line =~ s{\x08}{<BS>}xmsg;
		$line =~ s{\x09}{<HT>}xmsg;
		$line =~ s{\x0b}{<VT>}xmsg;
		$line =~ s{\x0c}{<FF>}xmsg;
		$line =~ s{\x0e}{<SO>}xmsg;
		$line =~ s{\x0f}{<SI>}xmsg;
		$line =~ s{\x10}{<DLE>}xmsg;
		$line =~ s{\x11}{<DC1>}xmsg;
		$line =~ s{\x12}{<DC2>}xmsg;
		$line =~ s{\x13}{<DC3>}xmsg;
		$line =~ s{\x14}{<DC4>}xmsg;
		$line =~ s{\x15}{<NAK>}xmsg;
		$line =~ s{\x16}{<SYN>}xmsg;
		$line =~ s{\x17}{<ETB>}xmsg;
		$line =~ s{\x18}{<CAN>}xmsg;
		$line =~ s{\x19}{<EM>}xmsg;
		$line =~ s{\x1a}{<SUB>}xmsg;
		$line =~ s{\x1b}{<ESC>}xmsg;
		$line =~ s{\x1c}{<FS>}xmsg;
		$line =~ s{\x1d}{<GS>}xmsg;
		$line =~ s{\x1e}{<RS>}xmsg;
		$line =~ s{\x1f}{<US>}xmsg;
		$line =~ s{\x7f}{<DEL>}xmsg;

		$line =~ s{\x9b}{<CSI>}xmsg;
		$line =~ s{\x9d}{<OSC>}xmsg;
		$line =~ s{\x90}{<DCS>}xmsg;

		$line =~ s{\x0d\x0a}{<CR><LF><NEWLINEMARKERHERE>}xmsg;
		$line =~ s{\x0d}{<CR><NEWLINEMARKERHERE>}xmsg;
		$line =~ s{\x0a}{<LF><NEWLINEMARKERHERE>}xmsg;
		$line =~ s{<NEWLINEMARKERHERE>}{\n}xmsg;
	}
	else
	{
		while ($line =~ s{[^$bs]$bs}{}xmsg) {}
	}

	# cursor movement commands, put a new line to set off the new text.
	$line =~ s{(${osc}0;)}{show_esc($1, "\n")}xmsge; # (ansi1,ansi8 test)

	$line =~ s{$bel}{show_esc("<BEEP>", "")}xmsge;

	$line =~ s{(${csi}[0-9;]*[ABCDEFfGHru])}{show_esc($1, "\n")}xmsge; # cursor move up/down etc (ansi1 test)

	# color change, etc just remove totally
	$line =~ s{(${csi}=\d*[hl])}{show_esc($1, "")}xmsge; # set/reset screen width/type (ansi3 test)
	$line =~ s{(${csi}\?\d+[hl])}{show_esc($1, "")}xmsge; # private modes invisible etc (ansi4 test)

	# clear screen, print a few lines (ansi7 test)
	$line =~ s{(${csi}2J)}{show_esc($1, "\n\n\n\n\n")}xmsge;

	$line =~ s{(${csi}[0-9;]*[JKmPps])}{show_esc($1, "")}xmsge; # erase screen, line, set graphics modes, set bold/dim/italic, etc (ansi2,ansi5,ansi7 test)
	$line =~ s{(${csi}[0-9;]+"[^"]*";p)}{show_esc($1, "")}xmsge; # (ansi6 test)
	$line =~ s{${esc}M}{\n}xmsg; # move cursor up one line/scroll (ansi9 test)
	$line =~ s{${esc}7}{}xmsg; # save cursor position (ansi9 test)
	$line =~ s{${esc}8}{\n}xmsg; # restore saved cursor position (ansi9 test)

	return $line;
}

# Sample console.error coloration from why-did-you-render
# %cComponent color: #058;
# console.group node_modules/@welldone-software/.../whyDidYouRender.js:700
sub clean_console_colors
{
	my ($line) = @ARG;
	while ($line =~ s{\%c(.*) color:\s*(\w+|\#[0-9a-fA-F]+);}{$1}xmsg) {}
	$line =~ s{node_modules/.+/(whyDidYouRender\.js)}{$1}xmsg;
	return $line;
}

my $start = time();
my $now = `date`;
echo(qq{$now\n\n});
if ($WRAP) {
   print "Will word wrap the log file output after $WRAP columns...\n";
}
if ($MODULUS) {
	print "Will only print every $MODULUS lines but will log them all...\n";
}

while (my $line = <STDIN>)
{
	my $clean = $line;
	# http://ascii-table.com/ansi-escape-sequences.php
	$clean = clean_ansi($clean);
	$clean = clean_console_colors($clean);
	$line  = clean_console_colors($line);
	echo_line($line, wrap($clean));
}

my $finish = `date`;
my $done = time();
my $seconds = $done - $start;
my $elapsed = $seconds;
my $HOUR = 60 * 60;

if ($elapsed > $HOUR)
{
	my $hours = int($elapsed / $HOUR);
	$seconds = ($elapsed - $HOUR * $hours) % $HOUR;
	$elapsed = plural($hours, 'hour') . ' ' . duration($seconds);
}
else
{
	$elapsed = duration($elapsed);
}

if ($elapsed eq '')
{
	$elapsed = '<1 second';
}

echo(qq{$finish\nElapsed: $elapsed\n});
close($fh);

__END__
# %cComponent color: #058;
# console.group node_modules/@welldone-software/.../whyDidYouRender.js:700
