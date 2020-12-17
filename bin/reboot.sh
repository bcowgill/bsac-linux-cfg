#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# force a reboot after 5 minutes if you get locked up
DATE=`date`
sudo shutdown -r +${1:-5} "
$DATE:
System will reboot automatically if things go wrong.
Use sudo shutdown -c 'Reboot cancelled' to cancel it.
"
