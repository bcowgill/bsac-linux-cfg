#!/bin/bash
#DISK=$1

#if [ -z "$DISK" ]; then
#	echo You must supply a disk device name i.e. sdb or /dev/sda to gather partition information from.
#	lsblk -f
#	exit 1
#fi
#DEV=`echo $DISK | perl -pne '$_ = "/dev/$_" unless m{\A/dev/}xms'`

function crlf
{
	local lines
	lines=${1:-2}
	perl -e "print(qq{\n} x $lines)"
}

function show
{
	local cmd
	cmd="$*"
	echo $cmd
	echo ==============================
	$cmd
	crlf
}

show lsblk --fs
show sudo parted --list
show sudo parted --list --machine

crlf
echo "Remember to use sudo parted --align optimal or minimal to prevent performance degradation when reading the filesystem."
