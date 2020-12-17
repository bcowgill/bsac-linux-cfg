#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# watch disk used/free space continually for a given directory
DIR=${1:-$HOME}
watch "df -k $DIR; echo ' '; du -h $DIR"

