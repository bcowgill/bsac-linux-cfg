#!/bin/bash
# watch disk free space continually
watch 'df -k | ~/bin/df-k.pl' 

