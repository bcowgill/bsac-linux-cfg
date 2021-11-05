#!/usr/bin/env perl

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

my $line_window = shift || 3;
my $buffer_size = 2 * $line_window + 1;

use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] file offset [lines]

This helps with JSON syntax errors cryptically given as error at offset NNN.

file         JSON file with syntax error.
offset       Byte offset reported by parser.
lines        Number of before/afer lines to display around the offset.
--help       shows help for this program.
--man        shows help for this program.
-?           shows help for this program.

This can help you find exactly where a JSON syntax error has happened when there are unexpected unicode characters in the file.

Example of error from webpack which does not show context:
SyntaxError: Unexpected string in JSON at position 3960 while parsing '{

See also json-reorder.pl, filter-whitespace.pl

Example:

$FindBin::Script language.json 32000 4 | filter-whitespace.pl

Display a 4 line window around the error at offset 32000 in the language.json file and replace whitespace characters with visible code characters.

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}
if (length($offset || "") < 1)
{
	usage();
}

print qq{JSON syntax error at offset $offset\n};

my $stop_line;
my $pointer = "Δ\n";
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

