#!/bin/bash
# See also greppw.sh vipw and vipw.sh

TOP=/media/me
ls $* $TOP/*/[pP]* | grep -i passwd
