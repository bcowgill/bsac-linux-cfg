#!/bin/bash
# Show how many files are in a directory
find $* -type f | wc -l
