#!/bin/bash
# show git log messages with relative age
git log --format="format:%h %cr %cn %s" $*
