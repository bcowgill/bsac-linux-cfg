#!/bin/bash
# Simple search to show the indentation structure of an html file so you can find mismatched tags.
# you should have the file indented with tabs.
# WINDEV tool useful on windows development machin
egrep 'div|fieldset|form|</?dl|</?dd' "$1"  | perl -pne 's{\t}{\\  }xmsg'
