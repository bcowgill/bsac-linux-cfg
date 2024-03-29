#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use utf8;         # so literals and identifiers can be in UTF-8
use v5.16;       # later version so we can use case folding fc() function directly
use strict;
use warnings;
use warnings  qw(FATAL utf8);   # fatalize encoding glitches
use open qw(:std :utf8);       # undeclared streams in UTF-8
use English qw(-no_match_vars);
use Fatal qw(open);

my $file = shift;
my $offset = shift;
my $error_line;
my $error_col;

my $line_window = shift || 3;
my $buffer_size = 2 * $line_window + 1;

use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] file [offset] [lines]

This helps with JSON syntax errors cryptically given as error at offset NNN.

file         JSON file with syntax error.
offset       Byte offset reported by parser [node -r for example].
lines        Number of before/afer lines to display around the offset.
--help       shows help for this program.
--man        shows help for this program.
-?           shows help for this program.

This can help you find exactly where a JSON syntax error has happened when there are unexpected unicode characters in the file.

Example of error from webpack which does not show context:
SyntaxError: Unexpected string in JSON at position 3960 while parsing '{

If you omit the offset the node and jq commands will be executed to require the JSON file and detect the error offset position.  You should specify a relative path to the file or you will get an error cannot find module.

See also show-line.sh, json-reorder.pl, filter-whitespace.pl

Example:

$FindBin::Script language.json 32000 4 | filter-whitespace.pl

	Display a 4 line window around the error at offset 32000 in the language.json file and replace whitespace characters with visible code characters.

Finding where error is in JSON:

	node -r ./error-tiny.json 2>&1 > /dev/null | grep SyntaxError

		SyntaxError: ..../error-tiny.json: Unexpected string in JSON at position 34

	jq '.' ./error-tiny.json 2>&1 > /dev/null | grep error

		parse error: Expected separator between values at line 3, column 11

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}
if (length($offset || "") < 1)
{
	my $parsed = `node -r "$file" -e "process.exit()" 2>&1 > /dev/null | grep Error`;
	print $parsed;

	if ($parsed =~ m{at\s+position\s+(\d+)}xms)
	{
		$offset = $1;
	}

	$parsed = `jq '.' "$file" 2>&1 > /dev/null | grep error`;
	print $parsed;

	if ($parsed =~ m{at\s+line\s+(\d+),\s+column\s+(\d+)}xms)
	{
		$error_line = $1;
		$error_col = $2;
	}
}
if (length($offset || "") < 1)
{
	usage();
}

print qq{JSON syntax error at offset $offset\n};

my $stop_line;
#⬆
#⬇
#my $pointer = "Δ\n";
my $pointer = "⬆\n";
my @Position = ();
my @Buffer = ();
my $chars = 0;
my $fh;
open($fh, "<", $file);

sub output
{
	print join("", shift(@Position), @Buffer);
}

while (my $line = <$fh>)
{
	my $here = $chars;
	$chars += length($line);
	push(@Position, qq{line $. \@$here:\n});
	if ($here <= $offset && $offset <= $chars)
	{
		push(@Buffer, $line . (" " x ($offset - $here)) . $pointer);
		$stop_line = $. + $line_window;
	}
	else
	{
		push(@Buffer, $line);
	}
	if ($stop_line && $. >= $stop_line)
	{
		last;
	}
	if (scalar(@Buffer) > $buffer_size)
	{
		shift(@Position);
		shift(@Buffer);
	}
}
output() if $stop_line;

