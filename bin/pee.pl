#!/usr/bin/env perl
# cat tests/filter-man/in/sample1.txt | pee.pl --control  xxx.log
# cat sample-script-ansi-escapes.log | pee.pl --control sample-script-ansi-escapes-cleaned-with-pee-pl.log; vim sample-script-ansi-escapes-cleaned-with-pee-pl.log
# WINDEV tool useful on windows development machine
use strict;
use warnings;
use FindBin;
use English qw(-no_match_vars);
use Fatal qw(open);
use POSIX;

sub usage
{
	my ($message) = @ARG;

	print qq{$message\n\n} if $message;
	print <<"USAGE";
$FindBin::Script [--control] [--append] [--help|--man|-?] file_name

Similar to tee but with date and elapsed time, line wrapping and removal of ANSI terminal control characters.

WRAP      environment variable specifying what colum to wrap for the log file. default 60.
--control shows ANSI ESC control sequences instead of replacing them with whitespace.
--append  appends to the named log file instead of overwriting it.
--help    shows help for this program.
--man     shows help for this program.
-?        shows help for this program.

This program will print standard input to standard output and clean it up before writing it to the log file.

See also tee, filter-script.pl, filter-whitespace.pl, filter-man.pl

Example:

npm test | $FindBin::Script tests.log

USAGE
	exit ($message ? 1 : 0);
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $SHOW_ESC = 0;
my $esc = qq{\x1b};
my $bel = qq{\x7};
my $bs = qq{\x8};
my $ESC = qq{ ESC};

# Get column wrap width from environment or use default
# COLUMNS env var is an alternative
my $WRAP = $ENV{WRAP} || 60;

if (scalar(@ARGV) && $ARGV[0] eq '--control')
{
	$SHOW_ESC = 1;
	shift;
}

my $mode = '>';
if (scalar(@ARGV) && $ARGV[0] eq '--append')
{
	$mode = '>>';
	shift;
}

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

sub wrap
{
	my ($line) = @ARG;
	chomp($line);
	my @lines = ();
	while (length($line) > $WRAP)
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
		$elapsed = floor($elapsed / 60);
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

	# backspace, bell
	if ($SHOW_ESC)
	{
		$clean =~ s{$bs}{<BS>}xmsg;
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

while (my $line = <STDIN>)
{
	my $clean = $line;
	# http://ascii-table.com/ansi-escape-sequences.php
	$clean = clean_ansi($clean);
	$clean = clean_console_colors($clean);
	$line  = clean_console_colors($line);
	echo($line, wrap($clean));
}

my $finish = `date`;
my $done = time();
my $seconds = $done - $start;
my $elapsed = $seconds;
my $HOUR = 60 * 60;

if ($elapsed > $HOUR)
{
	my $hours = floor($elapsed / $HOUR);
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

