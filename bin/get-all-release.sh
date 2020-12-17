#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

# cross-platform get full os release information
( which sw_vers > /dev/null 2>&1 && sw_vers ) \
|| ( which lsb_release > /dev/null 2>&1 && lsb_release -a )
