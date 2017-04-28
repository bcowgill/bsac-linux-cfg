#!/usr/bin/env perl
# correct comma placement for leading/trailing

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use open IN => ':raw';

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
	print STDERR "fixing leading commas are not yet implemented.";
	return $content;
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
