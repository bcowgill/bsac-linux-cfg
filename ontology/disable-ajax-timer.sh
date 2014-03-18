#!/bin/bash
# turn off the ajax timer call in mirrored web pages

MATCH='function doAjaxTimer' 
egrep -rl "$MATCH" .
perl -i.bak -pne 's{function \s+ doAjaxTimer \s* ( \( [^\)]* \) ) \s* \{ \s* \z}{function doAjaxTimer $1 \{ return; /* BSAC DISABLE AJAX TIMER REFRESH */\n}xms' `egrep -rl "$MATCH" . | head -1`

