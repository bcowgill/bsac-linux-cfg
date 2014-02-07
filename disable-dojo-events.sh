#!/bin/bash
# turn off dojo mouse events in mirrored web pages
MATCH="mouseOverHandler : function"
egrep -rl "$MATCH" . 
perl -i.bak -pne 's{ (mouse(Up|Down|Over|Out)Handler \s* : \s* function \s* \( [^\)]* \) \s* \{ ) \s* \z }{$1 return; /* BSAC DISABLE DOJO MOUSE EVENT HANDLER */\n}xms' \
   `egrep -rl "$MATCH" .` 

MATCH="function _1d"
egrep -rl "$MATCH" . 
perl -i.bak -pne 's{ (function \s+ _1d \s* \( [^\)]* \) \s* \{) \s* \z }{$1 return; /* BSAC DISABLE DOJO MOUSE EVENT HANDLER */\n}xms' \
   `egrep -rl "$MATCH" .` 

MATCH="var _18=function"
egrep -rl "$MATCH" . 
perl -i.bak -pne 's{ (var \s+ _18 \s* = \s* function \s* \( [^\)]* \) \s* \{) \s* \z }{$1 return; /* BSAC DISABLE DOJO MOUSE EVENT HANDLER */\n}xms' \
   `egrep -rl "$MATCH" .` 

MATCH="var _541"
egrep -rl "$MATCH" . 
perl -i.bak -pne 's{ (var \s+ _541 \s* = \s* function \s* \( [^\)]* \) \s* \{) \s* }{$1 return; /* BSAC DISABLE DOJO MOUSE EVENT HANDLER */\n}xms' \
   `egrep -rl "$MATCH" .` 
