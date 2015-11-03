#!/bin/bash
# filter out the fiels in the qa directory
# usage egrep -rl something | filter-qa.sh
egrep -v 'qa/'
