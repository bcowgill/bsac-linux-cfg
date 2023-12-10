#!/bin/bash
# https://linuxize.com/post/how-to-mount-iso-file-on-linux/

MNT=/media/iso
ISO=$1

echo mount an .iso file to extract the files.
if [ -z "$ISO" ]; then
	echo You must specify an .iso file name to mount on $MNT
	exit 1
fi

if [ ! -e $MNT ]; then
	echo making mount point: $MNT
	sudo mkdir $MNT
fi
sudo mount "$ISO" $MNT -o loop
ls $MNT
