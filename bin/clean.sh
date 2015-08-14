#!/bin/bash
DIR=.
find $DIR -type f -name '*.bak' -exec rm {} \;
