#!/bin/bash
# Monitor some system logs -- meant to be used on Ctrl-Alt-F1 terminal
pushd /var/log
tail -f auth.log syslog lastlog kern.log
