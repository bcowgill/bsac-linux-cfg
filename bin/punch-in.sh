#!/bin/bash
FILE=~/workspace/timeclock.txt
NOW=`( date --rfc-3339=seconds ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"`
echo punched in at $NOW. saved to $FILE
echo in at $NOW >> $FILE
