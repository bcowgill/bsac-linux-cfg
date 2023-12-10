#!/bin/bash
# List the disks that have boot partitions on them.

function usage {
	cmd=$0
	echo "You may have to run 'sudo $cmd' to have permission to examine the partition table for bootable disks."
	exit 1
}

if which parted > /dev/null ; then
	TMP=$(mktemp)
	if parted -l | grep -E '/dev|boot|Flags' > $TMP ; then
		perl -ne '
			my $line = $_;
			chomp($line);
			$device = $1 if m{(/dev/[^:]+):}xms;
			#print STDERR "[$line]\n";
			if (s{Number}{Device}xms)
			{
				#print STDERR $_;
				print unless $header_printed++;
			}
			print if s{\A\s*(\d+)}{$device$1}xms;
		' $TMP | grep -E --color 'Flags|/dev[^ ]+[0-9]+'
		rm $TMP
	else
		rm $TMP
		usage
	fi
	exit $?
fi
if fdisk -l | grep -vE 'sectors of [0-9]' | grep --color -B1 -E '/dev.+\*' ; then
	/bin/true
else
	usage
fi

exit $?
output from GNU parted:

Disk /dev/sdb: 4001GB
 1      1049kB  4001GB  4001GB  primary               boot
Disk /dev/sdc: 8025MB
 1      61.4kB  8025MB  8025MB  primary  fat32        boot, lba
Disk /dev/nvme0n1: 512GB
 1      1049kB  525MB   524MB   fat32           EFI system partition  boot


output from fdisk
WARNING: GPT (GUID Partition Table) detected on '/dev/nvme0n1'! The util fdisk doesn't support GPT. Use GNU Parted.

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *         256   976754623  3907017472    7  HPFS/NTFS/exFAT
--
   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1   *         120    15673343     7836612    c  W95 FAT32 (LBA)
