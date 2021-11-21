#!/bin/bash
browser.sh "file://`echo $0 | perl -pne 's{\.sh}{.html}'`#$1"
