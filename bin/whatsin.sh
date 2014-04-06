#!/bin/bash
# Show what kind of files are in a directory
find $* -type f -exec file {} \;
