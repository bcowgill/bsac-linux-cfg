#!/bin/bash
# watch java processes continually
watch 'ps -ef | egrep "perl|python|java" | grep -v watch | grep -v grep'

