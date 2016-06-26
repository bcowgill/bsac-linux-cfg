#!/usr/bin/env perl
# Correct file import paths when a source file has moved

use strict;
use warnings;

use English qw(-no_match_vars);
use Carp qw(croak);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $TEST_CASES = 15;

# ensure path begins with ./ and has no /./ inside
# and ends with / and has no //
# and remove /X/../ as it is redundant
# fatal if path has / or ~ at start
sub canonical_path
{
	my ($path) = @ARG;

	die("cannot use absolute or home paths [$path]") if ($path =~ m{\A [/~]}xms);
	$path = "./$path" if ($path !~ m{\A \./}xms);
	$path .= '/';
	$path =~ s{//+}{/}xmsg;
	$path =~ s{/\./}{/}xmsg;
	# remove X/../ as it is redundant
	$path =~ s{([^/]+)(/\.\./)}{ ($1 eq '..' || $1 eq '.') ? $1 . $2 : '' }xmsge;

	return $path;
}

# work out the relative path from one place to another
sub get_relative_path
{
	my ($from, $to) = map { canonical_path($ARG) } @ARG;

	my $common_prefix = get_common_prefix($from, $to);
   $from = substr($from, length($common_prefix));
	$to = substr($to, length($common_prefix));

	my $delta = $from;
	$delta =~ s{[^/]+(/|\z)}{../}xmsg;
	$delta .= "$to";

	return $delta;
}

# get common prefix path between two paths
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
	my ($from, $to, $import) = map { canonical_path($ARG) } @ARG;

   # work out full import path from source dir
	my $full_import = canonical_path($from . $import);
	$full_import =~ s{/ \z}{}xms;
	#print STDERR "full $full_import\n";

	# work out relative path to destination dir
	my $path = get_relative_path($to, $full_import);
	$path = "./$path" if ($path !~ m{\A \.}xms);
	$path =~ s{/ \z}{}xms;
	#print STDERR "relative $path\n";

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
	is($common, $expect, "get_common_prefix: [$from] [$to] == [$expect]");
}

sub test_get_common_prefix_ex
{
	my ($expect, $from, $to) = @ARG;

	throws_ok(sub { get_common_prefix($from, $to) }, qr{$expect}, "get_common_prefix: [$from] [$to] throws [$expect]");
}

sub test_fix_import_path
{
	my ($import, $expect, $from, $to) = @ARG;

   my $path = fix_import_path($from, $to, $import);

	is($path, $expect, "test_fix_import_path: mv [$from/File] -> [$to/]; import [$import] == [$expect]")
}

sub tests
{
	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	my $from = 'src/X';#/File';
	my $to   = 'src/Y/Z';

	test_get_common_prefix_ex('cannot use absolute or home paths \[/\]', '/', '~');
	test_get_common_prefix_ex('cannot use absolute or home paths \[~\]', '~', '/');
   test_get_common_prefix('./', '', '');
   test_get_common_prefix('./X/Y/', 'X/./Y', 'X///Y');
   test_get_common_prefix('./X/Z/', 'X/./Y/../Z', 'X///Z');
   test_get_common_prefix('./', $from, '');
   test_get_common_prefix('./src/', $from, $to);
   test_get_common_prefix('./', 'subdir', '../somewhere');
   test_get_common_prefix('./', './subdir', '../somewhere');
   test_get_common_prefix('./src/', "${from}xx", "${from}xyzzy");

	test_fix_import_path('./Something',     '../../X/Something', $from, $to);
	test_fix_import_path('./sub/Something', '../../X/sub/Something', $from, $to);

	test_fix_import_path('../Something',     '../../Something',   $from, $to);
	test_fix_import_path('../Y/Z/Something', './Something', $from, $to);
	test_fix_import_path('../Y/W/Something', '../W/Something', $from, $to);

	exit 0;
}

tests()
