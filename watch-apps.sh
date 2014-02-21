#!/bin/bash
# watch java processes continually
watch 'ps -ef | egrep "perl|python|java" | grep -v grep | grep -v what-is-running | what-is-running.pl'

