#!/usr/bin/env perl
# Correct file import paths when a source file has moved

use strict;
use warnings;

use English qw(-no_match_vars);

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $TEST_CASES = 1;

# ensure path has ./ on it before
sub canonical_path
{
	my ($path) = @ARG;

	$path = "./$path" if ($path !~ m{\A \./}xms);
	return $path;
}

sub get_common_prefix
{
	my ($from, $to) = map { canonical_path($ARG) } @ARG;

	my ($common, $length) = ('', length($from));
	for (my $spot = 1; $spot <= $length; ++$spot) {
		my $prefix = substr($from, 0, $spot);
		if ($prefix eq substr($to, 0, $spot)) {
			$common = $prefix;
      }
		else {
			last;
      }
   }
	$common =~ s{/ [^/]+ \z}{/}xms;
	return $common;
}

# fix a relative import path in a file when it moves to a new directory
sub fix_import_path
{
	my ($from, $to, $import) = @ARG;

	my $path = $import;
	return $path;
}

# fix an external import path referring to a file that has been moved to a new directory
sub fix_external_import_path
{
	my ($from, $to, $file, $import) = @ARG;

	my $path = $import;
	return $path;
}

sub test_get_common_prefix
{
	my ($expect, $from, $to) = @ARG;

	my $common = get_common_prefix($from, $to);
	is($common, $expect, "get_common_prefix: [$from] [$to] [$expect]");
}

sub test_fix_import_path
{
	my ($import, $expect, $from, $to) = @ARG;

   my $path = fix_import_path($from, $to, $import);

	is($path, $expect, "test_fix_import_path: mv [$from/File] -> [$to/]; import [$path]")
}

sub tests
{
	eval "use Test::More tests => $TEST_CASES";

	my $from = 'src/X';#/File';
	my $to   = 'src/Y/Z';

	my $reverse_delta = '../../X'; # s{\./}{$reverse_delta}

   test_get_common_prefix('./', '', '');
   test_get_common_prefix('./src/', $from, $to);
   test_get_common_prefix('./', $from, '');
   test_get_common_prefix('./', 'subdir', '../somewhere');
   test_get_common_prefix('./', './subdir', '../somewhere');
   test_get_common_prefix('./src/', "${from}xx", "${from}xyzzy");

	test_fix_import_path('./Something',  '../../X/Something', $from, $to);
	test_fix_import_path('../Something', '../../Something',   $from, $to);

	exit 0;
}

tests()
