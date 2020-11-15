#!/bin/bash
# Show how many files are in a directory
# WINDEV tool useful on windows development machine
find $* -type f | wc -l
