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
my $esc = qq{\x1b};
my $bel = qq{\x7};
my $bs = qq{\x8};
my $ESC = qq{ ESC};

# Get column wrap width from environment or use default
my $WRAP = $ENV{COLUMNS} eq "0" ? 0 : ($ENV{COLUMNS} || 60);
my $mode = '>';

sub output_control_for_test
{
	print qq{control   \a \b \f \t\n};
	print qq{control2  \x01 \x02 \x03 \x04 \x05 \x06 \x07 \x08 \x09 \x0b \x0c \x0e \x0f \x10 \x11 \x12 \x13 \x14 \x15 \x16 \x17 \x18 \x19 \x1a \x1b \x1c \x1d \x1e \x1f \x7f\n};
	print qq{backspace $bs$bs$bs\n};
	print qq{bell      $bel$bel$bel\n};
	print qq{esc       $esc$esc$esc\n};
	print qq{ansi $esc]0; $esc\[0A $esc\[B $esc\[0;45;C $esc\[D $esc\[f $esc\[H $esc\[u\n};
	print qq{ansi2 $esc\[K $esc\[0;9;m $esc\[0;9s\n};
	print qq{ansi3 $esc\[=h $esc\[=0;9l\n};
	print qq{ansi4 $esc\[\?h $esc\[\?90h\n};
	print qq{ansi5 $esc\[0;9p $esc\[0p\n};
	print qq{ansi6 $esc\[0;9;"";p $esc\[90"something";p\n};
	print qq{ansi7 $esc\[2J\n};
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
	elsif (scalar(@ARGV) && $ARGV[0] eq '--append')
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
	my ($clean) = @ARG;

   # MUSTDO See filter-script program and update this...
	# backspace, bell
	if ($SHOW_ESC)
	{
		# See hexdump manual page for control codes
		$clean =~ s{$bs}{<BS>}xmsg;
		$clean =~ s{$esc}{ ESC}xmsg;
		$clean =~ s{\x00}{<NUL>}xmsg;
		$clean =~ s{\x01}{<SOH>}xmsg;
		$clean =~ s{\x02}{<STX>}xmsg;
		$clean =~ s{\x03}{<ETX>}xmsg;
		$clean =~ s{\x04}{<EOT>}xmsg;
		$clean =~ s{\x05}{<ENQ>}xmsg;
		$clean =~ s{\x06}{<ACK>}xmsg;
		$clean =~ s{\x07}{<BEL>}xmsg;
		$clean =~ s{\x08}{<BS>}xmsg;
		$clean =~ s{\x09}{<HT>}xmsg;
		$clean =~ s{\x0b}{<VT>}xmsg;
		$clean =~ s{\x0c}{<FF>}xmsg;
		$clean =~ s{\x0e}{<SO>}xmsg;
		$clean =~ s{\x0f}{<SI>}xmsg;
		$clean =~ s{\x10}{<DLE>}xmsg;
		$clean =~ s{\x11}{<DC1>}xmsg;
		$clean =~ s{\x12}{<DC2>}xmsg;
		$clean =~ s{\x13}{<DC3>}xmsg;
		$clean =~ s{\x14}{<DC4>}xmsg;
		$clean =~ s{\x15}{<NAK>}xmsg;
		$clean =~ s{\x16}{<SYN>}xmsg;
		$clean =~ s{\x17}{<ETB>}xmsg;
		$clean =~ s{\x18}{<CAN>}xmsg;
		$clean =~ s{\x19}{<EM>}xmsg;
		$clean =~ s{\x1a}{<SUB>}xmsg;
		$clean =~ s{\x1b}{<ESC>}xmsg;
		$clean =~ s{\x1c}{<FS>}xmsg;
		$clean =~ s{\x1d}{<GS>}xmsg;
		$clean =~ s{\x1e}{<RS>}xmsg;
		$clean =~ s{\x1f}{<US>}xmsg;
		$clean =~ s{\x7f}{<DEL>}xmsg;

		$clean =~ s{\x0d\x0a}{<CR><LF><NEWLINEMARKERHERE>}xmsg;
		$clean =~ s{\x0d}{<CR><NEWLINEMARKERHERE>}xmsg;
		$clean =~ s{\x0a}{<LF><NEWLINEMARKERHERE>}xmsg;
		$clean =~ s{<NEWLINEMARKERHERE>}{\n}xmsg;
	}
	else
	{
		while ($clean =~ s{[^$bs]$bs}{}xmsg) {}
	}
	$clean =~ s{$bel}{show_esc("<BEEP>", "")}xmsge;

	# http://ascii-table.com/ansi-escape-sequences.php
	# cusror movement commands, put a space to set off the new text.
	$clean =~ s{($esc\]0;)}{show_esc($1, "\n")}xmsge;
	$clean =~ s{($esc\[[0-9;]*[ABCDfHu])}{show_esc($1, "\n")}xmsge;

	# color change, etc just remove totally
	$clean =~ s{($esc\[[0-9;]*[Kms])}{show_esc($1, "")}xmsge;
	$clean =~ s{($esc\[=[0-9]*[hl])}{show_esc($1, "")}xmsge;
	$clean =~ s{($esc\[\?[0-9]*h)}{show_esc($1, "")}xmsge;
	$clean =~ s{($esc\[[0-9;]+p)}{show_esc($1, "")}xmsge;
	$clean =~ s{($esc\[[0-9;]+"[^"]*";p)}{show_esc($1, "")}xmsge;

	# clear screen, print a few lines
	$clean =~ s{($esc\[2J)}{show_esc($1, "\n\n\n\n\n")}xmsge;
	return $clean;
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
