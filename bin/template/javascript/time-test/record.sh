#!/bin/bash
# record results of date functions with two time zones.
# after running, cp results.txt to results-YYYY-MM.txt to keep a record
TZ=Europe/London; export TZ
./go.sh > results.txt 2>&1

TZ=America/Vancouver; export TZ
./go.sh >> results.txt 2>&1
