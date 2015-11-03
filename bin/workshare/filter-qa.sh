#!/bin/bash
# filter out the files in the qa directory
# usage egrep -rl something | filter-qa.sh
egrep -v 'qa/'
