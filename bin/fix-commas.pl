#!/usr/bin/env perl
# correct comma placement for leading/trailing

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use open IN => ':raw';

my $LEADING = 0;
my $NL = m{\n};

sub fix_commas
{
	my ($content) = @ARG;
	if ($LEADING)
	{
		$content = fix_leading_spaces($content);
	}
	else
	{
		$content = fix_trailing_spaces($content);
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
	print STDERR "fixing trailing commas are not yet implemented.";
	return $content;
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
