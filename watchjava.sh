#!/bin/bash
# watch java processes continually
watch 'ps -ef | grep java | grep -v watch | grep -v grep'

