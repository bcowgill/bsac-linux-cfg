#!/bin/bash
# split a file on braces
# WINDEV tool useful on windows development machine
perl -pne 's[\}][\n}\n]xmsg; s[\{][{\n   ]xmsg; ' $*
