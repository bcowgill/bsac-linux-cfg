#!/bin/bash
FILE=~/workspace/timeclock.txt
NOW=`( date --rfc-3339=seconds ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"`
echo punched out at $NOW. saved to $FILE
echo out at $NOW >> $FILE
