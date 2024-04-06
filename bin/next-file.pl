#!/usr/bin/env perl
# for file in /.file /.file32 /here/.file path/filename filename.txt filename.tar.gz .secret.tar .secret.tar.gz dir/ sss. xxx ; do TEST=1 next-file.pl $file; done

use strict;
use warnings;

use English qw(-no_match_vars);
use File::Spec;
use FindBin;

sub usage
{
	my ($code) = @ARG;
	my $cmd = $FindBin::Script;

	print <<"USAGE";
$cmd [--help|--man|-?] pathname

This will take the pathname of a file or directory that exists and output the next numbered pathname that is available.

pathname  an existing file or directory which you want to use as a template to create a next-numbered version.
--help    shows help for this program.
--man     shows help for this program.
-?        shows help for this program.

Example names used:
  .file -> .file1
  filename -> filename1
  filename. -> filename1.
  filename.txt -> filename1.txt
  filename.tar.gz -> filename1.tar.gz
  file42.txt -> file43.txt

  Where the 1 will be incremented until the file name is not already in use.

See also mktemp, renumber-files.sh, renumber-by-time.sh, rename-files.sh, auto-rename.pl, cp-random.pl

Example:

Make a numbered backup of a given file.

  cp filename `$cmd filename`

USAGE
	exit($code || 0);
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}
if (scalar(@ARGV) && $ARGV[0] =~ m{\A-}xms)
{
	print "Invalid option $ARGV[0]\n\n";
	usage(1)
}

my $TEST = $ENV{TEST};
my $full = shift;

die "$full: does not exist." if (! -e $full && !$TEST);

my $next = next_file($full);
print qq{$next\n};

# answers with the next available numbered file name for an already existing file.
sub next_file
{
	my ($full) = @ARG;
	my ($volume, $path, $filename, $file, $ext) = splitparts($full);
	#print qq{$full => [$volume] [$path] [$filename] [$file] [$ext]\n};

	my $number = 0;
	$number = $1 if ($file =~ s{(\d+)\z}{}xms);

	my $next = $full;
	while (-e $next || $TEST)
	{
		++$number;
		$TEST = 0;
		if ($filename eq "")
		{
			my $sep = chop($path);
			$next = File::Spec->catpath($volume, qq{$path$number$sep});
			$path .= $sep;
		}
		else
		{
			$next = File::Spec->catpath($volume, $path, qq{$file$number$ext});
		}
	}
	return $next;
} # next_file()

# splits a full file name into volume, directories, filename (including extension), filename (without extension), extension
sub splitparts
{
	my ($full) = @ARG;
	my ($volume, $path, $filename) = File::Spec->splitpath($full);
	my $is_dotfile = $filename =~ s{\A\.}{}xms;

	my $file = $filename;
	$file =~ s{(\.[^.]*(\.[^.]*)?)\z}{}xms;
	my $ext = $1 || "";
	$file = '.' . $file if $is_dotfile;
	return ($volume, $path, $filename, $file, $ext);
} # splitparts()
