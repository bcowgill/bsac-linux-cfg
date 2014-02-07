#!/bin/bash
# split a file on braces
perl -pne 's[\}][\n}\n]xmsg; s[\{][{\n   ]xmsg; ' $*
