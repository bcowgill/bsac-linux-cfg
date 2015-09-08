#!/bin/bash
# watch disk used/free space continually for a given directory
DIR=${1:-$HOME}
watch "df -k $DIR; echo ' '; du -h $DIR"

