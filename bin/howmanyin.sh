#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Show how many files are in a directory
# WINDEV tool useful on windows development machine
find $* -type f | wc -l
