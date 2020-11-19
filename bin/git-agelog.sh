#!/bin/bash
# show git log messages with relative age
# WINDEV tool useful on windows development machine
git log --format="format:%h %cr %cn %s" $*
