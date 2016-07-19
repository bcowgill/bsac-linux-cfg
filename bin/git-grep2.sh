#!/bin/bash
# simple git grep for lines containing both expressions, highlighting the first one
git grep "$1" | grep "$2" | grep --color "$1"
