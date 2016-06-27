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

our $TEST_CASES = 89;

# ensure path begins with ./ and has no /./ inside
# and ends with / and has no //
# and remove /X/../ as it is redundant
# fatal if path has / or ~ at start
sub canonical_path
{
	my ($path) = @ARG;

	croak("cannot use absolute or home paths [$path]") if ($path =~ m{\A [/~]}xms);
	$path = "./$path" if ($path !~ m{\A \./}xms);
	$path .= '/';
	$path =~ s{//+}{/}xmsg;
	$path =~ s{/\./}{/}xmsg;

	# remove X/../ as it is redundant
	my $last;
	do {
		$last = $path;
		$path =~ s{
			([^/]+)(/\.\./)
		}{
			($1 eq '..' || $1 eq '.') ? $1 . $2 : ''
		}xmsge;
	} while ($last ne $path);

	return $path;
}

# canonical path but begins with ./ or ../ insteat of ./../
sub short_path
{
	my ($path) = map { canonical_path($ARG) } @ARG;

	$path =~ s{\A \./ (\.\./)}{$1}xms;
	return $path;
}

sub canonical_filepath
{
	my ($filepath) = @ARG;

	my $path = canonical_path($filepath);
	$path =~ s{/ \z}{}xms;

	return $path;
}

sub short_filepath
{
	my ($filepath) = @ARG;

	my $path = short_path($filepath);
	$path =~ s{/ \z}{}xms;

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
	$delta = short_path($delta);

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

# modify a path to go up a directory
sub up_dir
{
	my ($path) = map { canonical_path($ARG) } @ARG;

	unless ($path =~ s{/([^/]+)/ \z}{($1 eq '..') ? '/../../' : '/'}xmse)
	{
		$path .= '../';
	}
	return $path;
}

# modify a path to go up a directory but not past the current directory
sub up_dir_limited
{
	my ($path) = map { canonical_path($ARG) } @ARG;

	croak("cannot go up past current directory [$path]") if $path =~ m{\.\./}xms;
	my $up = up_dir($path);
	croak("cannot go up past current directory [$path]") if $up =~ m{\.\./}xms;
	return $up;
}

# modify a path to go down into a directory
sub into_dir
{
	my ($path, $dir) = map { canonical_path($ARG) } @ARG;

	croak("cannot go down into a parent directory [$path] [$dir]") if $dir =~ m{\A \./ \.\./}xms;
	$path .= $dir;
	return canonical_path($path);
}

sub change_dir_relative
{
	my ($path, $relative) = map { canonical_path($ARG) } @ARG;

	my @paths = split('/', $relative);
	foreach my $move (@paths)
	{
		next if $move eq '.';
		$path = ($move eq '..') ? up_dir($path) : into_dir($path, $move);
	}
	return $path;
}

sub change_dir_relative_limited
{
	my ($path, $relative) = map { canonical_path($ARG) } @ARG;

	my @paths = split('/', $relative);
	foreach my $move (@paths)
	{
		next if $move eq '.';
		$path = ($move eq '..') ? up_dir_limited($path) : into_dir($path, $move);
	}
	return $path;
}

sub get_path_filename
{
	my ($path) = map { canonical_filepath($ARG) } @ARG;

	my $filename;
	$path =~ s{/ ([^/]+) \z}{$filename = $1; '/'}xmse;

	return ($path, $filename);
}

# fix a relative import path in a file when it moves to a new directory
sub fix_import_path
{
	my ($from, $to, $import) = map { canonical_path($ARG) } @ARG;

   # work out full import path from source dir
	my $full_import = canonical_filepath($from . $import);
	#print STDERR "full $full_import\n";

	# work out relative path to destination dir
	my $path = short_filepath(get_relative_path($to, $full_import));
	#print STDERR "relative $path\n";

	return $path;
}

# fix an external import path referring to a file that has been moved to a new directory
sub fix_external_import_path
{
	my ($from, $to, $external_file, $import) = map { canonical_path($ARG) } @ARG;

	$external_file = canonical_filepath($external_file);
	$import = canonical_filepath($import);
	#print STDERR "external_file $external_file\n";
	#print STDERR "from $from\n";
	#print STDERR "to $to\n";
	#print STDERR "import $import\n";

   my ($import_path, $import_file) = get_path_filename($import);
	#print STDERR "import [$import_path] [$import_file]\n";

	my $from_file = short_filepath($from . $import_file);
	#print STDERR "from_file [$from_file]\n";

	my ($file_path, $filename) = get_path_filename($external_file);
	#print STDERR "import from [$file_path] [$filename]\n";
	my $full_import = canonical_filepath($file_path . $import);
	#print STDERR "full_import $full_import\n";

   # check that full import path is same as source path
	# otherwise we are not referring to the same actual file being imported
	# and should just return the original import path
	my $path = short_filepath($import);
	if ($full_import eq $from_file)
	{
		my $relative_import = get_relative_path($from, $to);
		my $relative = get_relative_path($file_path, $to);
		#print STDERR "relative_import $relative_import\n";
		#print STDERR "relative $relative\n";

		$path = short_filepath($relative . $import_file);
		#print STDERR "new import $path\n";
	}

	return $path;
}

#===========================================================================

sub test_canonical_path_ex
{
	my ($expect, $path) = @ARG;

	throws_ok(sub { canonical_path($path) }, qr{$expect}, "canonical_path: [$path] throws [$expect]");
}

sub test_canonical_path
{
	my ($expect, $path) = @ARG;

	my $canon = canonical_path($path);
	is($canon, $expect, "canonical_path: [$path] == [$expect]")
}

sub test_canonical_filepath
{
	my ($expect, $path) = @ARG;

	my $canon = canonical_filepath($path);
	is($canon, $expect, "canonical_filepath: [$path] == [$expect]")
}

sub test_short_path
{
	my ($expect, $path) = @ARG;

	my $short = short_path($path);
	is($short, $expect, "short_path: [$path] == [$expect]")
}

sub test_short_filepath
{
	my ($expect, $path) = @ARG;

	my $short = short_filepath($path);
	is($short, $expect, "short_filepath: [$path] == [$expect]")
}

sub test_get_common_prefix
{
	my ($expect, $from, $to) = @ARG;

	my $common = get_common_prefix($from, $to);
	is($common, $expect, "get_common_prefix: [$from] [$to] == [$expect]");
}

sub test_get_relative_path
{
	my ($expect, $from, $to) = @ARG;

	my $relative = get_relative_path($from, $to);
	is($relative, $expect, "get_relative_path: [$from] [$to] == [$expect]");
}

sub test_up_dir
{
	my ($expect, $path) = @ARG;

	my $up = up_dir($path);
	is($up, $expect, "up_dir: [$path] == [$expect]");
}

sub test_up_dir_limited_ex
{
	my ($expect, $path) = @ARG;

	throws_ok(sub { up_dir_limited($path) }, qr{$expect}, "up_dir_limited: [$path] throws [$expect]");
}

sub test_up_dir_limited
{
	my ($expect, $path) = @ARG;

	my $up = up_dir_limited($path);
	is($up, $expect, "up_dir_limited: [$path] == [$expect]");
}

sub test_into_dir_ex
{
	my ($expect, $path, $dir) = @ARG;

	throws_ok(sub { into_dir($path, $dir) }, qr{$expect}, "into_dir: [$path] throws [$expect]");
}

sub test_into_dir
{
	my ($expect, $path, $dir) = @ARG;


	my $into = into_dir($path, $dir);
	is($into, $expect, "into_dir: [$path] == [$expect]");
}

sub test_change_dir_relative
{
	my ($expect, $path, $relative) = @ARG;

	my $new = change_dir_relative($path, $relative);
	is($new, $expect, "change_dir_relative: [$path] [$relative] == [$expect]");
}

sub test_change_dir_relative_limited
{
	my ($expect, $path, $relative) = @ARG;

	my $new = change_dir_relative_limited($path, $relative);
	is($new, $expect, "change_dir_relative_limited: [$path] [$relative] == [$expect]");
}

sub test_change_dir_relative_limited_ex
{
	my ($expect, $path, $relative) = @ARG;

	throws_ok(sub { change_dir_relative_limited($path, $relative) }, qr{$expect}, "change_dir_relative_limited: [$path] [$relative] throws [$expect]");
}

sub test_fix_import_path
{
	my ($import, $expect, $from, $to) = @ARG;

   my $path = fix_import_path($from, $to, $import);

	is($path, $expect, "test_fix_import_path: mv [$from/File] -> [$to/]; import [$import] == [$expect]")
}

sub test_fix_external_import_path
{
	my ($expect, $file, $import, $from, $to) = @ARG;

   my $path = fix_external_import_path($from, $to, $file, $import);

	is($path, $expect, "test_fix_external_import_path: mv [$from/File] -> [$to/]; $file: import [$import] == [$expect]")
}

sub tests
{
	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	my $from = 'src/X';#/File';
	my $to   = 'src/Y/Z';

	test_canonical_path_ex('cannot use absolute or home paths \[/\]', '/');
	test_canonical_path_ex('cannot use absolute or home paths \[~\]', '~');
   test_canonical_path('./', '');
   test_canonical_path('./X/Y/', 'X/./Y');
   test_canonical_path('./X/Y/', 'X///Y');
   test_canonical_path('./src/', 'src');
   test_canonical_path('./Y/', 'X/../Y');
   test_canonical_path('./../X/Y/', '../X/Y');
   test_canonical_path('./X/A/B/C/D/', 'X/Y/Z/../../A/B/C/D');
   test_canonical_path('./X/Z/A/B/D/', 'X/Y/../Z/A/B/C/../D');

   test_canonical_filepath('./File.name', 'File.name');
   test_canonical_filepath('./X/Y/File.name', 'X/./Y/File.name');
   test_canonical_filepath('./X/Y/File.name', 'X///Y/File.name');
   test_canonical_filepath('./src/File.name', 'src/File.name');
   test_canonical_filepath('./Y/File.name', 'X/../Y/File.name');
   test_canonical_filepath('./../X/Y/File.name', '../X/Y/File.name');

   test_short_path('./', '');
   test_short_path('./X/Y/', 'X/./Y');
   test_short_path('./X/Y/', 'X///Y');
   test_short_path('./src/', 'src');
   test_short_path('./Y/', 'X/../Y');
   test_short_path('../X/Y/', './../X/Y');

   test_short_filepath('./File.name', 'File.name');
   test_short_filepath('./X/Y/File.name', 'X/./Y/File.name');
   test_short_filepath('./X/Y/File.name', 'X///Y/File.name');
   test_short_filepath('./src/File.name', 'src/File.name');
   test_short_filepath('./Y/File.name', 'X/../Y/File.name');
   test_short_filepath('../X/Y/File.name', '../X/Y/File.name');

	test_get_relative_path('./', 'src/', 'src');
	test_get_relative_path('./Y/Z/', 'src/', './src/Y/Z/');
	test_get_relative_path('../Y/Z/', 'src/X', './src/Y/Z/');
   test_get_relative_path('./', 'X/./Y', 'X///Y');
   test_get_relative_path('./', 'X/./Y/../Z', 'X///Z');
   test_get_relative_path('../../', $from, '');
   test_get_relative_path('../Y/Z/', $from, $to);
   test_get_relative_path('../../somewhere/', 'subdir', '../somewhere');
   test_get_relative_path('../../somewhere/', './subdir', '../somewhere');
   test_get_relative_path('../Xxyzzy/', "${from}xx", "${from}xyzzy");

   test_get_common_prefix('./', '', '');
   test_get_common_prefix('./X/Y/', 'X/./Y', 'X///Y');
   test_get_common_prefix('./X/Z/', 'X/./Y/../Z', 'X///Z');
   test_get_common_prefix('./', $from, '');
   test_get_common_prefix('./src/', $from, $to);
   test_get_common_prefix('./', 'subdir', '../somewhere');
   test_get_common_prefix('./', './subdir', '../somewhere');
   test_get_common_prefix('./src/', "${from}xx", "${from}xyzzy");

   test_up_dir('./src/X/', 'src/X/Y');
   test_up_dir('./', 'src');
   test_up_dir('./../', '');
   test_up_dir('./../../', '..');
   test_up_dir('./../', '../X');
   test_up_dir('./../../../', '../..');

   test_up_dir_limited('./src/X/', 'src/X/Y');
   test_up_dir_limited('./', 'src');
   test_up_dir_limited_ex('cannot go up past current directory \[\./\]', '');
   test_up_dir_limited_ex('cannot go up past current directory \[\./\.\./\]', '..');
   test_up_dir_limited_ex('cannot go up past current directory \[\./\.\./X/\]', '../X');
   test_up_dir_limited_ex('cannot go up past current directory \[\./\.\./\.\./\]', '../..');

   test_into_dir_ex('cannot go down into a parent directory \[\./src/X/Y/\] \[\./\.\./\]', 'src/X/Y', '..');
   test_into_dir('./src/X/Y/Down/', 'src/X/Y', 'Down');
   test_into_dir('./src/Down/', 'src', 'Down');
   test_into_dir('./Down/', '', 'Down');
   test_into_dir('./../Down/', '..', 'Down');

   test_change_dir_relative('./src/', 'src', '');
   test_change_dir_relative('./', 'src', '..');
   test_change_dir_relative('./../', '', '..');
   test_change_dir_relative('./src/Down/', 'src', 'Down');
   test_change_dir_relative('./src/Down/deeper/deeper/', 'src', 'Down/deeper/and/../deeper');

   test_change_dir_relative_limited('./src/', 'src', '');
   test_change_dir_relative_limited('./', 'src', '..');
   test_change_dir_relative_limited_ex('cannot go up past current directory', '', '..');
   test_change_dir_relative_limited('./src/Down/', 'src', 'Down');
   test_change_dir_relative_limited('./src/Down/deeper/deeper/', 'src', 'Down/deeper/and/../deeper');

	test_fix_import_path('../Y/Z/Something',   './Something',     $from, $to);
	test_fix_import_path('../Y/Z/R/Something', './R/Something',   $from, $to);
	test_fix_import_path('../Y/Something',     '../Something',    $from, $to);
	test_fix_import_path('../Y/W/Something',   '../W/Something',  $from, $to);
	test_fix_import_path('../Something',       '../../Something', $from, $to);
	test_fix_import_path('./Something',        '../../X/Something', $from, $to);
	test_fix_import_path('./sub/Something',    '../../X/sub/Something', $from, $to);

   test_fix_external_import_path('../Y/Z/File', 'src/X/Something.js', './File', $from, $to);
   test_fix_external_import_path('./Y/Z/File',  'src/Something.js',   './X/File', $from, $to);
   test_fix_external_import_path('../../Y/Z/File', 'src/X/W/Something.js', '../File', $from, $to);
   test_fix_external_import_path('./Z/File', 'src/Y/Something.js', '../X/File', $from, $to);
   test_fix_external_import_path('./File', 'src/Y/Z/Something.js', '../../X/File', $from, $to);
   test_fix_external_import_path('../File', 'src/Y/Z/W/Something.js', '../../../X/File', $from, $to);
   test_fix_external_import_path('../Y/Z/File', 'src/W/Something.js', '../X/File', $from, $to);
   test_fix_external_import_path('../../Y/Z/File', 'src/W/R/Something.js', '../../X/File', $from, $to);

	# Not the same File being imported, just same filename
   test_fix_external_import_path('./File', 'src/W/Something.js', './File', $from, $to);

	exit 0;
}

tests()
