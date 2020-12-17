#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Correct file import paths when a source file has moved.
# Does not support rename except to File/index.js by creating a linker
# index.js to File.js
# WINDEV tool useful on windows development machine

use strict;
use warnings;

use English qw(-no_match_vars);
use Carp qw(croak);
use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Slurp qw(:std :edit);
use autodie qw(open cp);
use FindBin;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $TEST_CASES = 114;
our $DRY_RUN = $ENV{DRY_RUN} || 0;
our $TRACE = 0;

our $REGEX_MODULE = qr{\.(jsx?|css|less|s[ac]ss) \z}xms;
our $REGEX_JS = qr{\.(js) \z}xms;

main();

#===========================================================================
# application functions
#===========================================================================

sub usage
{
	my ($reason) = @ARG;
	my $cmd = $FindBin::Script;

	print STDERR "$reason\n\n" if $reason;

	print << "USAGE";
$cmd from-file moved-to-file [external files ...]

This script corrects require or import references in a source file which has already been moved to a new location. It also corrects import references to the moved file when they are mentioned in external files. It supports a moved-to-file named index.js by assuming it is an import loader for DirName.js where moved-to-file is of the form path/DirName/index.js. In this case it will write the import as import DirName from 'path/DirName', instead of path/DirName/index

It does not support renaming a source file.
It does not support absolute path names in the from and moved to file names.
It only affects imports which have a relative path indication.

These would be corrected:

... import .... './path/Object'
... require ... '../path/Object'
... requireJson ... '../path/Object'

These would not be corrected:

... import .... 'path/Object'
... import js from '!!raw!./ScopedSelectors.js';

See also fix-import-order.pl JSTOOLS
USAGE

	exit($reason ? 1 : 0);
}

sub main
{
	my ($source, $source_path, $source_filename,
		$target, $target_path, $target_filename,
		$new_import_name, $raExternal) = check_args();

	if ($TRACE)
	{
		print STDERR "$target_path $target => $source_path $source $new_import_name\n";
	}
	fix_internal_imports($target, $source_path, $target_path, $source);
	foreach my $external (@$raExternal)
	{
		fix_external_imports($external, $source_path, $target_path, $source_filename, $new_import_name);
	}
}

sub check_args
{
	my ($source, $target, @External) = @ARGV;

	tests() if (($source || '') =~ m{\A --test}xms);
	usage() if (($source || '') =~ m{\A --help}xms);

	usage('parameter error: you must provide the old location of the moved file.') unless $source;
	usage('parameter error: you must provide the new location of the moved file.') unless $target;

	my ($source_path, $source_filename) = get_path_filename($source);
	my ($target_path, $target_filename) = get_path_filename($target);
	my $new_import_name = $target_filename;

	# special handling for the index.js linker file
	if ($target_filename eq 'index.js')
	{
		my ($discard_path, $container_dir) = get_path_filename($target_path);
		$new_import_name = $target_filename;
		my ($discard, $final_dir) = get_path_filename($target_path);
		$target_filename = "$final_dir.js";
		$target =~ s{index\.js \z}{$target_filename}xms;
	}
	else
	{
		usage("the file name for from-file and moved-to-file must be identical. [$source_filename] [$target_filename]") unless $source_filename eq $target_filename;
	}

	return ($source, $source_path, $source_filename,
		$target, $target_path, $target_filename,
		$new_import_name, \@External);
}

sub fix_internal_imports
{
	my ($target, $source_path, $target_path, $source) = @ARG;

	print "\n$target: fixing internal relative imports.\n";
	if ($DRY_RUN)
	{
		my $filename = -e $target ? $target : $source;
		my @includes = get_imports($filename);

		foreach my $rhImport (@includes)
		{
			my $import = fix_import_path($source_path, $target_path, $rhImport->{import});
			show_change($rhImport, $import);
		}
	}
	else
	{
		process_internal_imports($target, $source_path, $target_path);
	}
}

sub fix_external_imports
{
	my ($external, $source_path, $target_path, $source_filename, $new_import_name) = @ARG;

	print "\n$external: fixing external relative imports of $source_filename.\n";
	if ($DRY_RUN)
	{
		my @includes = get_imports($external, $source_filename);
		foreach my $rhImport (@includes)
		{
			my $import = fix_external_import_path($source_path, $target_path, $external, $rhImport->{import}, $new_import_name);
			show_change($rhImport, $import);
		}
	}
	else
	{
		process_external_imports($external, $source_path, $target_path, $source_filename, $new_import_name);
	}
}

sub show_change
{
	my ($rhImport, $changed) = @ARG;

	print qq{    $rhImport->{loader} $rhImport->{quote}$rhImport->{import}$rhImport->{quote}\n};
	print qq{==> $rhImport->{loader} $rhImport->{quote}$changed$rhImport->{quote}\n};
	#print Dumper($rhImport);
}

# extract all relevant imports from a file
# i.e. only relative path imports
# and only the specifically named module if specified
sub get_imports
{
	my ($filename, $module) = @ARG;

	my @includes = ();

	my $regex = prepare_matcher($module);

	my $rContent = read_file( $filename, scalar_ref => 1 );

	$$rContent =~ s{$regex}{
		my $rhFound = {};
		$rhFound->{prefix} = $1;
		$rhFound->{loader} = $2;
		$rhFound->{infix}  = $3;
		$rhFound->{quote}  = $4;
		$rhFound->{import} = $5;
		push(@includes, $rhFound);
		''
	}xmsge;

	return @includes;
}

sub process_internal_imports
{
	my ($filename, $source_path, $target_path) = @ARG;

	my $regex = prepare_matcher();

	my $rContent = read_file( $filename, scalar_ref => 1 );
	my $original = $$rContent;

	$$rContent =~ s{$regex}{
                #print STDERR "match [$&]\n";
		my $rhFound = {};
		$rhFound->{prefix} = $1;
		$rhFound->{loader} = $2;
		$rhFound->{infix}  = $3;
		$rhFound->{quote}  = $4;
		$rhFound->{import} = $5;

		my $changed = fix_import_path($source_path, $target_path, $rhFound->{import});
		show_change($rhFound, $changed);
		qq{$rhFound->{prefix}$rhFound->{loader}$rhFound->{infix}$rhFound->{quote}$changed$rhFound->{quote}};
	}xmsge;

	commit_changes($filename, \$original, $rContent);
}

sub process_external_imports
{
	my ($filename, $source_path, $target_path, $module, $new_import_name) = @ARG;

	my $regex = prepare_matcher($module);

	my $rContent = read_file( $filename, scalar_ref => 1 );
	my $original = $$rContent;

	$$rContent =~ s{$regex}{
		my $rhFound = {};
		$rhFound->{prefix} = $1;
		$rhFound->{loader} = $2;
		$rhFound->{infix}  = $3;
		$rhFound->{quote}  = $4;
		$rhFound->{import} = $5;

		my $changed = fix_external_import_path($source_path, $target_path, $filename, $rhFound->{import}, $new_import_name);
		show_change($rhFound, $changed);
		qq{$rhFound->{prefix}$rhFound->{loader}$rhFound->{infix}$rhFound->{quote}$changed$rhFound->{quote}};
	}xmsge;

	commit_changes($filename, \$original, $rContent);
}

sub commit_changes
{
	my ($filename, $rOriginal, $rChanged) = @ARG;

	my $backup = "$filename.bak";
	if ($$rChanged ne $$rOriginal)
	{
		#print $$rChanged;
		cp($filename, $backup);
		write_file($filename, $rChanged);
	}
	else
	{
		print "    no imports to fix.\n";
	}
}

sub prepare_matcher
{
	my ($module) = @ARG;

	my $filter = module_regex($module);

	my $regex = qr{
		((?:\A|\n) [^'"]*?) \b(import|require|requireJson)\b ([^'"]*?)
		(['"]) (\. [^'"]*? $filter) \4
		}xms;
#(.*? (?:\z|\n))
	#print STDERR "prepare_matcher $module $regex\n";

	return $regex;
}

sub module_regex
{
	my ($module) = @ARG;

	my $ext;
	if ($module) {
		if ($module =~ s{$REGEX_MODULE}{ $ext = $1; ''}xmse)
		{
			$module = quotemeta($module) . "(?:\\.$ext)?";
		}
		else
		{
			$module = quotemeta($module) . '(?:\.(?:jsx?|css|less|s[ac]ss))?';
		}
		$module = qr{$module};
	}
	else
	{
		$module = '';
	}

	return $module;
}

sub module_name
{
	my ($module) = @ARG;

	$module =~ s{$REGEX_MODULE}{}xms;

	return $module;
}

#===========================================================================
# low level path and import related functions
#===========================================================================

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
	my ($from, $to, $import) = @ARG;
	my $path = $import;
	eval
	{
		($from, $to, $import) = map { canonical_path($ARG) } @ARG;

		# work out full import path from source dir
		my $full_import = canonical_filepath($from . $import);
		#print STDERR "full $full_import\n";

		# work out relative path to destination dir
		$path = short_filepath(get_relative_path($to, $full_import));
		#print STDERR "relative $path\n";
	};
	if ($EVAL_ERROR)
	{
		warn("WARN: import $import: $EVAL_ERROR");
	}

	return $path;
}

# fix an external import path referring to a file that has been moved to a new directory
sub fix_external_import_path
{
	my ($from, $to, $external_file, $import, $import_name) = @ARG;

	my $path = $import;
	eval
	{
		($from, $to, $external_file, $import) = map { canonical_path($ARG) } @ARG;
		$path = short_filepath($import);
		$external_file = canonical_filepath($external_file);
		$import = canonical_filepath($import);
		print STDERR "external_file $external_file\n" if $TRACE;
		print STDERR "from $from\n" if $TRACE;
		print STDERR "to $to\n" if $TRACE;
		print STDERR "import $import\n" if $TRACE;
		print STDERR "import_name $import_name\n" if $TRACE;

		my ($import_path, $import_file) = get_path_filename($import);
		print STDERR "import [$import_path] [$import_file]\n" if $TRACE;

		my $from_file = short_filepath($from . $import_file);
		print STDERR "from_file [$from_file]\n" if $TRACE;

		my ($file_path, $filename) = get_path_filename($external_file);
		print STDERR "import from [$file_path] [$filename]\n" if $TRACE;
		my $full_import = canonical_filepath($file_path . $import);
		print STDERR "full_import $full_import\n" if $TRACE;

		# check that full import path is same as source path
		# otherwise we are not referring to the same actual file being imported
		# and should just return the original import path
		if ($full_import eq $from_file)
		{
			my $relative_import = get_relative_path($from, $to);
			my $relative = get_relative_path($file_path, $to);
			print STDERR "relative_import $relative_import\n" if $TRACE;
			print STDERR "relative $relative\n" if $TRACE;

			$path = short_filepath($relative . $import_file);
			if ($import_name eq 'index.js')
			{
				print STDERR "fixup: $import_file $import_name $path\n" if $TRACE;
				$path =~ s{$import_file/$import_file\z}{$import_file}xms;
			}

			print STDERR "new import $path\n" if $TRACE;
		}
	};
	if ($EVAL_ERROR)
	{
		warn("WARN: import $import: $EVAL_ERROR");
	}

	print STDERR "fixed: $path\n\n" if $TRACE;
	return $path;
}

#===========================================================================
# unit test functions
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

	is($path, $expect, "fix_import_path: mv [$from/File] -> [$to/]; import [$import] == [$expect]");
}

sub test_fix_external_import_path
{
	my ($expect, $file, $import, $from, $to, $new_import_name) = @ARG;

	my $show_to;
	if ($new_import_name)
	{
		$to .= "/$new_import_name";
		$show_to = "$to/$new_import_name.js + index.js";
	}
	else
	{
		my ($discard, $filename) = get_path_filename($from);
		$new_import_name = $filename;
		$show_to = "$to/";
   }
	my $path = fix_external_import_path($from, $to, $file, $import, $new_import_name);

	is($path, $expect, "fix_external_import_path: mv [$from/File] -> [$show_to]; $file: import as [$new_import_name] [$import] == [$expect]");
}

sub test_module_regex
{
	my ($expect, $module) = @ARG;

	my $regex = module_regex($module);
	is($regex, $expect, "module_regex: [$module] == [$expect]");
}

sub test_module_name
{
	my ($expect, $module) = @ARG;

	my $name = module_name($module);
	is($name, $expect, "module_name: [$module] == [$expect]");
}

sub test_module_regex_match
{
	my ($expect, $module, $import) = @ARG;

	my $regex = module_regex($module);
	is($import =~ qr{$regex\z} ? 'match' : 'nomatch', $expect, "module_regex match: [$module] [$import] == [$expect]");
}

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	my $from = 'src/X';#/File';
	my $to   = 'src/Y/Z';
	my $rename = 'Rename';

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
	test_fix_external_import_path('../../Y/Z/File.js', 'src/W/R/Something.js', '../../X/File.js', $from, $to);

	# Not the same File being imported, just same filename
	test_fix_external_import_path('./File', 'src/W/Something.js', './File', $from, $to);
	test_fix_external_import_path('./File.js', 'src/W/Something.js', './File.js', $from, $to);

	# Renaming the file with index.js
	test_fix_external_import_path('../Y/Z/File', 'src/X/Something.js', './File', $from, $to, $rename);

	test_module_regex('', '');
	test_module_regex('(?^:ClickMeComponent(?:\.(?:jsx?|css|less|s[ac]ss))?)', 'ClickMeComponent');
	test_module_regex('(?^:ClickMeComponent(?:\.js)?)', 'ClickMeComponent.js');
	test_module_name('', '');
	test_module_name('ClickMeComponent', 'ClickMeComponent');
	test_module_name('ClickMeComponent', 'ClickMeComponent.js');
	test_module_name('ClickMeComponent.story', 'ClickMeComponent.story.js');
	test_module_name('ClickMeComponent.story', 'ClickMeComponent.story');

	test_module_regex_match('match', 'Blah.jsx', './Blah');
	test_module_regex_match('match', 'Blah.js', './Blah');
	test_module_regex_match('nomatch', 'Blah.js', './Blah.css');
	test_module_regex_match('nomatch', 'Blah.js', './Blah/Module');
	test_module_regex_match('match', 'Blah', './Blah');
	test_module_regex_match('match', 'Blah', './Blah.css');
	test_module_regex_match('match', 'Blah', './Blah.js');
	test_module_regex_match('match', 'Blah', './Blah.jsx');
	test_module_regex_match('match', 'Blah', './Blah.less');
	test_module_regex_match('match', 'Blah', './Blah.sass');
	test_module_regex_match('match', 'Blah', './Blah.js');
	test_module_regex_match('match', 'Blah', './Blah.css');
	test_module_regex_match('nomatch', 'Blah', './Blah.ppp');
	test_module_regex_match('nomatch', 'Blah', './Nope');

	exit 0;
}
