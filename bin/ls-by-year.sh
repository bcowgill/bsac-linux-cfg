#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# list directories showing the year and name only
# assumes years begin with 20NN
ls -ltp --time-style=+%Y | perl -ne 'if (m{\s (20\d\d) \s (.+?) / \n \z}xms) { print "$1 [$2]\n"; }'
