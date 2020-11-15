#!/bin/bash
# Show what kind of files are in a directory
# WINDEV tool useful on windows development machine
find $* -type f -exec file {} \;
