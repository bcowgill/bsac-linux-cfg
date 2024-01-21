#!/bin/bash
# See also ls-pw.sh vipw vipw.sh

TOP=/media/me
if [ `ls $TOP/*/PASSWDS.TXT | wc -l` == 0 ]; then
	zipgrep "-i -A 6" $* $TOP/*/passwd.zip
#zipgrep "-i -B 6" $* $TOP/*/passwd.zip
#zipgrep "-i -C 6" $* $TOP/*/passwd.zip
else
	grep -iA6 $* $TOP/*/PASSWDS.TXT
fi
