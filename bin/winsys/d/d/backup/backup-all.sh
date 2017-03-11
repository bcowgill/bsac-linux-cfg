#!/bin/bash
echo Backing up everything of interest and logging to backup.log

PATH=/usr/local/bin:/usr/bin:$PATH

(\
./backup-win.sh;\
./backup-chrome.sh;\
./backup-email.sh;\
./backup-apps.sh;\
./save-user-chrome-storage.sh;\
./save-root-chrome-storage.sh;\
) 2>&1 | /usr/bin/tee backup.log
##./backup-picasa.sh;\


#perl -e "print STDERR qq{ERROR test capture of STDERR in log\n\n}"

echo " "
echo "==========================================================="
echo " "
echo Results of backup:
ls -al root/ root/win/ root/chrome/ velda/ velda/win/ velda/chrome/

echo Backup is complete press \<ENTER\> to exit
./pause.sh
