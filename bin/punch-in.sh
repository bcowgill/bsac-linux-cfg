#!/bin/bash
FILE=~/workspace/timeclock.txt
NOW=`( datestamp.sh ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"`
echo punched in at $NOW. saved to $FILE
echo in at $NOW >> $FILE
