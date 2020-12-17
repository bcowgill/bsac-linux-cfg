#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# Compare system and hardware clock settings
#Sat May  9 06:33:48 UTC 2015
#Sat 09 May 2015 06:33:49 UTC  -0.755865 seconds

echo "Timezone:  $TZ"
echo "Sys Clock:" `date +"%a %d %b %Y %T %Z"`
echo "HW  Clock:" `sudo hwclock --utc --show`
HOLD_TZ=TZ
TZ=UTC
echo "Sys Clock:" `date --utc +"%a %d %b %Y %T %Z"`
echo "HW  Clock:" `sudo hwclock --utc --show`
TZ="$HOLD_TZ"

echo "Fake Clck:" `cat /etc/fake-hwclock.data 2>&1`

#tzselect # command to see time zone names
#sudo hwclock --debug # try if unable to connect to hw clock
#sudo date --utc MMDDhhmm  # to set the system date
#sudo service ntp start  # to start the time server daemon

if ( command -v adjtimex > /dev/null 2>&1 ) ; then
	adjtimex --print | egrep -i 'status: [01234567]'|| echo NOT OK linux kernel 11 minute clock sync mode is OFF
	adjtimex --print | egrep -i 'status: [89abcdef]'|| echo OK linux kernel 11 minute clock sync mode is ON
else
	echo NOT OK adjtimex not installed
fi

# show state of clock related services
service ntp status
service fake-hwclock status
sudo service hwclock.sh show
ls /etc/rc*.d/*ntp* /etc/rc*.d/*hwclock*
ls -al /etc/cron*/*ntp* /etc/cron*/*hwclock*
ls -al /tmp/hwclock*

echo /etc/adjtime settings:
ls -al /etc/adjtime
cat /etc/adjtime
