#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

# monitor some operation you are doing
# See also op.sh, alarm-if.sh, alarm.sh, mynotify.sh, check-ezbackup-finished.sh
op.sh
echo " "
# show battery, temperature and network information
power.sh
ls-ips.sh
