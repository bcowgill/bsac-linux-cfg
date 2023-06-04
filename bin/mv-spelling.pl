#!/usr/bin/env perl
# locate beatrice | mv-spelling.pl beatrice beatrix

{ use 5.006; }
use strict;
use warnings;

use English qw(-no_match_vars);
use FindBin;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DRY = 0;
my $DEBUG = 0;

our $usage = 0;
our $dirs = 0;
our $files = 0;
our $errors = 0;
our $skipped = 0;
our $duplicates = 0;

sub usage
{
	my ($error) = @ARG;

	$usage = 1;
	print "$error\n\n" if $error;

	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [--dry] [--debug] incorrect correct

This program will read directory and file names from standard input and search for the incorrect text and replace it with the correct text, renaming the directories and files.

incorrect  some text in the file name that is incorrect.
correct    the correct text for file names.
--dry      do a dry run, prints what would be moved but doesn't do it.
--debub    print out debug information.
--help     shows help for this program.
--man      shows help for this program.
-?         shows help for this program.

The input should come from a command like find or locate with directories appearing before the files contained within it.

See also auto-rename.pl mv-apostrophe.sh mv-to-year.sh mv-camera.sh rename-files.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

Example:

For all the directories and files on disk containing beatrice change it to beatrix.

locate beatrice | $FindBin::Script beatrice beatrix

USAGE

	exit($error ? 1 : 0);
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

while ($ARGV[0] =~ m{^-})
{
	my $arg = shift;
	my $known = 0;
	if ($arg =~ m{\A--?dr}xms) # --dryrun
	{
		$DRY = 1;
		$known = 1;
	}
	if ($arg =~ m{\A--?de}xms) # --debug
	{
		++$DEBUG;
		$known = 1;
	}
	usage("unknown parameter $arg provided, please study the command usage below.") if (!$known);
}

my $find = shift;
my $replace = shift;

usage("missing search and replace text for file name spell correction.") unless $find && $replace;

my %Dirs = ();
my @Dirs = ();

print qq{# Dry run, commands will be shown but not executed.\n} if $DRY;

debug("rename files or directories changing $find to $replace");
while (my $path =  <>)
{
	chomp($path);

	my $to = $path;
	$to =~ s{$find}{$replace}g;

	if ($path ne $to)
	{
		if (-d $path)
		{
			debug("dir: $path");
			$Dirs{$path} = $to;
			@Dirs = sort bylength keys(%Dirs);
			debug(Dumper(\@Dirs));
			debug(Dumper(\%Dirs));
			move($path, $to, "# dir");
		}
		elsif (-f $path)
		{
			debug("file: $path");
			move($path, $to, "");
		}
		else
		{
			warn(qq{WARN: "$path" is missing, not a file or dir, skipping.\n});
			++$skipped;
		}
	}
}

sub bylength
{
	return length($a) <=> length($b);
}

sub is_dir_moved
{
	my ($path) = @ARG;
	my $original = $path;
	my $changed;
	foreach my $dir (@Dirs)
	{
		my $to = $Dirs{$dir};
		if ($path ne $dir && $path =~ s{$dir}{$to})
		{
			debug(qq{change: "$original" dir "$dir" => "$path"});
			$changed = $path;
		}
	}
	return $changed;
}

sub move
{
	my ($from, $to, $dir) = @ARG;
	if (! -e $to)
	{
		debug(qq{move "$from" "$to" $dir});
		my $now_path = is_dir_moved($from);
		if ($dir)
		{
			++$dirs;
		}
		else
		{
			++$files;
		}
		sys(qq{mv "@{[$now_path || $from]}" "$to" $dir}, $dir);
	}
	else
	{
		warn(qq{WARN destination "$to" already exists will not move "$from" there. $dir});
		++$duplicates;
	}
}

sub sys
{
	my ($cmd, $dir) = @ARG;
	if ($DRY)
	{
		print qq{$cmd\n};
	}
	else
	{
		debug("system: $cmd\n");
		if (!system($cmd))
		{
			die "ABORT. Directory could not be renamed <$cmd>." if $dir;
			++$errors;
		}
	}
	debug("");
}

sub debug
{
	print(@ARG) if $DEBUG;
	print("\n") if $DEBUG;
}

END
{
	unless ($usage) {
		my $context = $DRY ? "would be" : "were";
		print("$dirs directories $context moved.\n");
		print("$files files $context moved.\n");
		print("$skipped source paths $context skipped.\n");
		print("$duplicates destination paths $context duplicates and also skipped.\n");
		print("$errors errors trying to move files.\n");
	}
}

__END__
