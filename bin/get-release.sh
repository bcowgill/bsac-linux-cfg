#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# cross-platform os release version name/number
( which sw_vers > /dev/null 2>&1 && sw_vers -productVersion ) \
|| ( which lsb_release > /dev/null 2>&1 && lsb_release -sc )
