#!/bin/bash
# perform ls command on mobile phone directory mounted on MTP

if [ -e ~/.PHONE ]; then
	source ~/.PHONE
fi

if [ -z "$MTP" ]; then
	echo MTP has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

if [ -z "$phone" ]; then
	echo phone has not been configured. Please define it in ~/.PHONE file
	exit 10
fi

#MTP=/data/me/mtp
#phone=$MTP/Phone

if [ -e $phone ]; then
	echo $MTP
	ls -al $MTP
else
	echo `ls $phone` use mnt-phone.sh to mount your phone. > /dev/stderr
	exit 2
fi