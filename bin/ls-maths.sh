#!/bin/bash
# List all math symbols except for letters and numbers
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
grep-utf8.sh math | grep -vE '(Uppercase|Lowercase|Other)Letter|DecimalNumber'
