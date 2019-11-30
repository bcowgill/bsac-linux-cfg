#!/usr/bin/env perl
# correct comma placement for leading/trailing

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use open IN => ':raw';
use FindBin;

my $LEADING = 0;
my $NL = qr{\n};

sub fix_commas
{
	my ($content) = @ARG;
	if ($LEADING)
	{
		$content = fix_leading_commas($content);
	}
	else
	{
		$content = fix_trailing_commas($content);
	}
	print $content;
}

sub fix_leading_commas
{
	my ($content) = @ARG;
	my @lines = split($NL, $content);
	my $lines = scalar(@lines);
	if ($lines > 1)
	{
		for (my $idx = 0; $idx < $lines - 1; $idx++)
		{
			my ($line, $next, $moved) = move_trailing_comma_to_next_line(
				$lines[$idx],
				$lines[$idx + 1]
			);
			$lines[$idx + 1] = $next;
			$lines[$idx] = $line;
		}
		$content = join("\n", @lines);
		chomp($content);
	}
	return "$content\n";
}

sub fix_trailing_commas
{
	my ($content) = @ARG;
	my @lines = split($NL, $content);
	my $lines = scalar(@lines);
	if ($lines > 1)
	{
		for (my $idx = 1; $idx < $lines; $idx++)
		{
			my ($prev, $line, $moved) = move_leading_comma_to_previous_line(
				$lines[$idx - 1],
				$lines[$idx]
			);
			$lines[$idx - 1] = $prev;
			if ($moved)
			{
				$line = add_trailing_comma($line) if (($idx + 1 < $lines) && in_a_list($line, $lines[$idx + 1]));
			}
			$lines[$idx] = $line;
		}
		$content = join("\n", @lines);
		chomp($content);
	}
	return "$content\n";
}

sub move_trailing_comma_to_next_line
{
	my ($line, $next) = @ARG;
	my $moved;
	##print "\n\nl:$line\nn:$next\n\n" if $line =~ m{param3} || $next =~ m{param3};
	($line, $moved) = strip_trailing_comma($line);
	##print "\n\nm:$moved\nl:$line\nn:$next\n\n" if $line =~ m{param3} || $next =~ m{param3};
	if ($moved)
	{
		# only if next line is not ) ] }
		$next = add_leading_comma($next) unless $next =~ m{ \A \s* [\)\]\}] }xms;
	}
	return ($line, $next, $moved);
}

sub move_leading_comma_to_previous_line
{
	my ($prev, $line) = @ARG;
	my $moved = 0;
	if ($line =~ s{\A (\s*) , (\s*)}{$1}xms)
	{
		$moved = 1;
		$prev = add_trailing_comma($prev);
	}
	return ($prev, $line, $moved);
}

sub add_leading_comma
{
	my ($line) = @ARG;
	$line =~ s{ \A (\s*) }{$1, }xms;
	return $line;
}

sub add_trailing_comma
{
	my ($line) = @ARG;
	unless ($line =~ s{ (\s* /\* .*? \*/ \s*) \z}{,$1}xms)
	{
		unless ($line =~ s{ (\s* // .*?) \z}{,$1}xms)
		{
			$line .= ',';
		}
	}
	return $line;
}

# Does next line begin with ] ) or } and current line does not end with , ;
sub in_a_list
{
	my ($line, $next) = @ARG;
	my $in_a_list = ($next =~ m{\A \s* [\)\}\]]}xms)
		&& !has_trailing_punctuation($line);
	return $in_a_list;
}

sub has_trailing_punctuation
{
	my ($line) = @ARG;
	my $has_trailing = ($line =~ m{ [,;] (\s* /\* .*? \*/ \s*) \z}xms
		|| $line =~ m{ [,;] (\s* // .*?)? \z}xms);
	return $has_trailing;
}

sub strip_trailing_comma
{
	my ($line) = @ARG;
	##print "\n\ns:$line\n\n" if $line =~ m{param3};
	my $moved = ($line =~ s{ , (\s* /\* .*? \*/ \s*) \z}{$1||""}xmsge
		|| $line =~ s{ , (\s* // .*?)? \z}{$1||""}xmsge);
	return ($line, $moved);
}

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	print <<"USAGE";
usage: $FindBin::Script [--leading] [--help] filename...

Fixes comma placement in files specified.  Default is to move leading commas on a line to the end of the previous line.

--leading causes trailing commas to be placed as leading commas on the next line.

i.e.
	var thisThing // this thing
		, thatThing; // that thing

becomes

	var this, // this thing
		that; // that thing

and vice versa if --leading is specified.

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] eq '--leading')
{
	$LEADING = 1;
	shift(@ARGV);
}

if (scalar(@ARGV))
{
	# filename given, open file with binary mode
	my $content = read_file($ARGV[0]);
	fix_commas($content);
}
else
{
	# no filename given, parsing standard input
	local $INPUT_RECORD_SEPARATOR = undef;
	fix_commas(<>);
}
