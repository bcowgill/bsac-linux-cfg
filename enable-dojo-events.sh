#!/bin/bash
# turn on dojo mouse events in mirrored web pages
MATCH="BSAC DISABLE DOJO MOUSE"
egrep -rl "$MATCH" . 
perl -i.bak -pne 's{ return; \s* /\* \s+ BSAC \s+ DISABLE \s+ DOJO \s+ MOUSE \s+ EVENT \s+ HANDLER \s+ \*/}{}xms' \
   `egrep -rl "$MATCH" .` 

MATCH="data-bsac-disabled-"
egrep -rl "$MATCH" . 
perl -i.bak -pne 's{ data-bsac-disabled- }{}xmsg' \
   `egrep -rl "$MATCH" .` 
