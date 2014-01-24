#!/bin/bash
# watch java processes continually
watch 'ps -ef | egrep "perl|python|java" | grep -v grep | what-is-running.pl'

