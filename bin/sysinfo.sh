#!/bin/bash
echo RAM info:
free -ght | perl -ne 'if (m{Mem:\s+(\S+)}xms) { print "$1 Physical RAM\n" }'
cat /proc/meminfo | head -1

echo " "
echo Disk info:
sudo fdisk -l 2> /dev/null | grep -E 'Disk\s+/'
lsblk -d | grep disk

sudo ls-boot.sh

gnome-system-monitor &

exit
free outpu:
Mem:           15G        15G       179M       221M       1.1G       487M
