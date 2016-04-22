#!/usr/bin/env perl
# compare files in two directories and delete the ones that are identical
# ./delsame.pl "./WD/acer_5720/Memeo/acer_5720/C_/Users/Public/Music/Sample Music" "./WD/acer_5720/Memeo/acer_5720/C_/Users/me/Documents/pda/htc-hd2-leo/AKSTON-16GB-OLD/MUSIC/Aaron Goldberg/Worlds"

use strict;
use English qw(-no_match_vars);
use Fatal qw(opendir unlink);
use File::Spec;
use Data::Dumper;

my $DEBUG = 0;

my ($delete, $keep) = @ARGV;

my $TALK = 0;
my $SHOW_ONLY = 0;
my $LS = 1;
my $DUMP = 0;

if ($DEBUG)
{
	$TALK = $SHOW_ONLY = $LS = $DUMP = $DEBUG;
}


my $dh;

my %Both = ();
my %DeleteOnly = ();
my %KeepOnly = ();

my %Delete = ();
my %NoDelete = ();

my %Checksums = ();

say("delete from:  $delete", "if files match", "the files in: $keep");

# check that keep dir exists
opendir($dh, $keep);
closedir($dh);

# process the delete dir
opendir($dh, $delete);
while (my $file = readdir($dh))
{
	my $delete_filename = File::Spec->catfile($delete, $file);
	next if -d $delete_filename;
	info("$file") unless $LS;
	my $keep_filename = File::Spec->catfile($keep, $file);

	# skip it if file not in other directory
	unless (-f $keep_filename)
	{
		$DeleteOnly{$file} = track_checksum('delete', $delete_filename, $file);
		if ($LS)
		{
			say("[in delete only] $DeleteOnly{$file} $file");
		}
		next;
	}

	info("maybe delete $delete_filename");
	$Both{$file} = [track_checksum('keep', $keep_filename, $file), track_checksum('delete', $delete_filename, $file)];
	if ($LS)
	{
		say("[in both dirs]   @{[join(' ', @{$Both{$file}})]} $file");
	}

	my $same = $Both{$file}[0] eq $Both{$file}[1];
	if ($same)
	{
		delete_file($delete_filename, $file, $Both{$file}[0]);
	}
	else
	{
		$NoDelete{$file} = 1;
	}
}
closedir($dh);

# try to locate duplicates using checksums on whatever remains
opendir($dh, $keep);
while (my $file = readdir($dh))
{
	my $keep_filename = File::Spec->catfile($keep, $file);
	next if -d $keep_filename;
	unless ($Delete{$file})
	{
		$KeepOnly{$file} = track_checksum('keep', $keep_filename, $file);
		if ($LS)
		{
			say("[in keep only]   $KeepOnly{$file} $file");
		}
	}
}
closedir($dh);

# delete files which match checksums of something in the keep dir
foreach my $checksum (keys(%Checksums))
{
	info("checksum diff? $checksum");
	my $matches_shown;
	if (exists($Checksums{$checksum}{'delete'}) && exists($Checksums{$checksum}{'keep'}))
	{
		foreach my $filename (keys(%{$Checksums{$checksum}{'delete'}}))
		{
			unless ($matches_shown)
			{
				say("checksum $checksum for keep files:", map { "   $ARG" } values(%{$Checksums{$checksum}{'keep'}}), "will delete:");
				$matches_shown = 1;
			}
			delete_file($filename, $Checksums{$checksum}{'delete'}{$filename}, $checksum);
		}
	}
}

my $maybe_del = $SHOW_ONLY ? " would be" : "";
my $maybe_not_del = $SHOW_ONLY ? " would not be" : " not";
say(scalar(keys %Both) . " in both dirs",
	scalar(keys %Delete) . "$maybe_del deleted",
	scalar(keys %NoDelete) . "$maybe_not_del deleted",
	scalar(keys %DeleteOnly) . " in delete only",
	scalar(keys %KeepOnly) . " in keep only"
	);

if ($DUMP)
{
	dump_var('%Both', \%Both);
	dump_var('%Delete', \%Delete);
	dump_var('%NoDelete', \%NoDelete);
	dump_var('%DeleteOnly', \%DeleteOnly);
	dump_var('%KeepOnly', \%KeepOnly);
	dump_var('%Checksums', \%Checksums);
}

#==========================================================================
# Subroutines

sub track_checksum
{
	my ($type, $filename, $file) = @ARG;
	my $checksum = checksum($filename);
	$Checksums{$checksum}{$type}{$filename} = $file;
	return $checksum;
}

sub checksum
{
	my ($filename) = @ARG;
	my ($fh, $result, $md5sum);

	info("md5sum $filename");
	open($fh, '-|', 'md5sum', $filename);
	$result = <$fh>;
	close($fh);
	($md5sum) = split(/\s/, $result);
	return $md5sum;
}

sub delete_file
{
	my ($filename, $file, $checksum) = @ARG;
	say("delete $filename");
	$Delete{$file} = 1;
	unlink($filename) unless ($SHOW_ONLY);
	$Checksums{$checksum}{'deleted'}{$filename} = $file;
	delete $Checksums{$checksum}{'delete'}{$filename};
}

sub say
{
	my (@Message) = @ARG;

	push(@Message, "");
	print join("\n", @Message);
}

sub info
{
	my (@Message) = @ARG;

	push(@Message, "");
	print join("\n", @Message) if ($TALK);
}

sub dump_var
{
	my ($name, $var) = @ARG;

	my $dump = Dumper($var);
	$dump =~ s{\A \$VAR1}{$name}xms;
	say($dump);
}
