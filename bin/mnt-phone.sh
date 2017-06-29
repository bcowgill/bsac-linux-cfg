# unmount and remount the phone on MTP
MTP=/data/me/mtp
fusermount -u $MTP
jmtpfs $MTP
echo $MTP
ls -al $MTP
