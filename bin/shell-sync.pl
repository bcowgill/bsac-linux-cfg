#!/usr/bin/env perl
# poor man's rsync analyse two find listings and generate shell commands
# to synchronize a directory
# useful for MTP mounted mobiles which work unreliably on rsync

# cd d/backup
# scan-phone.sh
# A:
# ./go.sh
# when i/o errors happen from MTP device restart
# fusermount -u /data/me/mtp
# jmtpfs /data/me/mtp
# find-ez.sh samsung-galaxy-note4-edge/phone > phone-backup.lst
# shell-sync.pl /data/me/mtp/Phone samsung-galaxy-note4-edge/phone phone.lst phone-backup.lst > go.sh
# back to A:

use strict;
use warnings;

use English qw(-no_match_vars);

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Slurp qw(:std);
use autodie qw(open cp);

my ($remoteDir, $backupDir, $remoteFile, $backupFile) = @ARGV;


#my ($remoteFile, $backupFile) = scan_directories($remoteDir, $backupDir);
my $rhChanges = analyse_changes($remoteDir, $backupDir, $remoteFile, $backupFile);
my $counter;

#print Dumper($rhChanges);

shell_sync($remoteDir, $backupDir, $rhChanges);

sub scan_directories
{
	my ($remoteDir, $backupDir) = @ARG;
	my ($remoteFile, $backupFile) = ('phone.lst', 'phone-backup.lst');
	scan_directory($remoteDir, $remoteFile);
	scan_directory($backupDir, $backupFile);
	return ($remoteFile, $backupFile);
}

sub scan_directory
{
	my ($dir, $file) = @ARG;
	system(qq{find-ez.sh "$dir" > "$file"});
}

sub analyse_changes
{
	my ($remoteDir, $backupDir, $remoteFile, $backupFile) = @ARG;
	$remoteDir =~ s{/\z}{}xmsg;
	$backupDir =~ s{/\z}{}xmsg;
	my $rhRemoteFiles = parse_listing($remoteDir, $remoteFile);
	my $rhBackupFiles = parse_listing($backupDir, $backupFile);
	my $raDeleteFiles = [];
	my $raCopyNewFiles = [];
	my $raUpdateFiles = [];
	my $raSameSize = [];
	my $raSameFiles = [];

	foreach my $file (keys(%$rhRemoteFiles))
	{
		if (exists($rhBackupFiles->{$file}))
		{
			my $change = change_type($rhRemoteFiles->{$file}, $rhBackupFiles->{$file});
			if ($change eq 'none')
			{
				push(@$raSameFiles, $file);
			}
			elsif ($change eq 'size')
			{
				push(@$raUpdateFiles, $file);
			}
			else
			{
				push(@$raSameSize, $rhBackupFiles->{$file});
			}
			delete($rhBackupFiles->{$file});
		}
		else
		{
			push(@$raCopyNewFiles, $file);
		}
	}
	foreach my $file (keys(%$rhBackupFiles))
	{
		push(@$raDeleteFiles, $file);
	}

	return {
		remote => $rhRemoteFiles,
		backup => $rhBackupFiles,
		delete => $raDeleteFiles,
		new    => $raCopyNewFiles,
		update => $raUpdateFiles,
		samesize => $raSameSize,
		same   => $raSameFiles,
	};
}

sub shell_sync
{
	my ($remoteDir, $backupDir, $rhChanges) = @ARG;
	$remoteDir =~ s{/\z}{}xmsg;
	$backupDir =~ s{/\z}{}xmsg;
	print qq{# synchronize files from "$remoteDir/" to "$backupDir/"\n};
	print qq{#set -x\n};
	my $fn = <<'EOFN';
	update () {
		local source target
		source="$1"
		target="$2"
		cmp --quiet "$source" "$target" || cp -p "$source" "$target"
	}
EOFN
	$fn =~ s{(\A|\n)\t}{$1}xmsg;
	print qq{\n$fn};
	$counter = scalar(@{$rhChanges->{new}}) + scalar(@{$rhChanges->{update}})
		+ scalar(@{$rhChanges->{delete}}) + scalar(@{$rhChanges->{samesize}});

	sync_changed($remoteDir, $backupDir, $rhChanges->{update}, $rhChanges->{remote});
	sync_new($remoteDir, $backupDir, $rhChanges->{new}, $rhChanges->{remote});
	sync_same_size($remoteDir, $backupDir, $rhChanges->{samesize}, $rhChanges->{remote});
	sync_delete($backupDir, $rhChanges->{delete});
}

sub parse_listing
{
	my ($dir, $listingFile) = @ARG;
	my $raContent = read_file($listingFile, array_ref => 1);
	my $rhFiles = {};
	$dir =~ s{/\z}{}xmsg;
	foreach my $line (@$raContent)
	{
		chomp($line);
		my ($file, $size, $time) = split(/\t/, $line);
		$file =~ s{"(\.|$dir)/}{"}xmsg;
		$rhFiles->{$file} = {
			file => $file,
			size => $size,
			time => $time,
		}
	}
	return $rhFiles;
}

sub change_type
{
	my ($rhRemote, $rhBackup) = @ARG;
	my $type = 'none';
	if ($rhRemote->{size} != $rhBackup->{size})
	{
		$type = 'size';
	}
	elsif ($rhRemote->{time} ne $rhBackup->{time})
	{
		$type = 'time';
	}
	return $type;
}

sub sync_new
{
	my ($remoteDir, $backupDir, $raNew, $rhRemoteFiles) = @ARG;
	my $rhNewDir = {};
	my @newFiles = sort bySize @$raNew;
	my $number = scalar(@newFiles);
	print qq{\n### copy new files: $number\n};
	foreach my $file (@newFiles)
	{
		my ($from, $to) = ($file, $file);
		my $size = $rhRemoteFiles->{$file}{size};
		$from =~ s{\A"}{"$remoteDir/}xmsg;
		$to   =~ s{\A"}{"$backupDir/}xmsg;
		my $toDir = $to;
		$toDir =~ s{/ [^/]+ \z}{"}xmsg;
		print qq{\nmkdir -p $toDir > /dev/null\n} unless exists($rhNewDir->{$toDir});
		count();
		print qq{cp -p $from $to # $size bytes\n};
		$rhNewDir->{$toDir} = 1;
	}
}

sub sync_changed
{
	my ($remoteDir, $backupDir, $raChanged, $rhRemoteFiles) = @ARG;
	my $number = scalar(@$raChanged);
	print qq{\n### update files: $number\n};
	foreach my $file (sort bySize @$raChanged)
	{
		my ($from, $to) = ($file, $file);
		my $size = $rhRemoteFiles->{$file}{size};
		$from =~ s{\A"}{"$remoteDir/}xmsg;
		$to   =~ s{\A"}{"$backupDir/}xmsg;
		count();
		print qq{cp -p $from $to # $size bytes \n};
	}
}

sub sync_same_size
{
	my ($remoteDir, $backupDir, $raChanged, $rhRemoteFiles) = @ARG;
	my $number = scalar(@$raChanged);
	print qq{\n### update same size files: $number\n};
	foreach my $rhChanged (sort bySizeInfo @$raChanged)
	{
		my $file = $rhChanged->{file};
		my $backupTime = $rhChanged->{time};
		my ($from, $to) = ($file, $file);
		my $size = $rhRemoteFiles->{$file}{size};
		my $remoteTime = $rhRemoteFiles->{$file}{time};
		$from =~ s{\A"}{"$remoteDir/}xmsg;
		$to   =~ s{\A"}{"$backupDir/}xmsg;
		count();
		print qq{update $from $to # $size bytes $remoteTime $backupTime\n};
	}
}

sub sync_delete
{
	my ($backupDir, $raDelete) = @ARG;
	my $number = scalar(@$raDelete);
	print qq{\n### delete files: $number\n};
	foreach my $file (sort(@$raDelete))
	{
		$file =~ s{\A"}{"$backupDir/}xmsg;
		print qq{echo $counter...\nrm $file\n};
		--$counter;
	}
}

sub bySize
{
	my $rhA = $rhChanges->{remote}{$a};
	my $rhB = $rhChanges->{remote}{$b};
	return $rhA->{size} <=> $rhB->{size};
}

sub bySizeInfo
{
	return $a->{size} <=> $b->{size};
}

sub count
{
	print qq{echo $counter remaining ...\n};
	--$counter;
}
