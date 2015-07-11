#!/bin/bash
rm -rf td
echo setup test dirs
tar xvzf test-files.tgz
echo make mocha dark
../../use-mocha-dark.sh
echo verify output dirs
find td -ls | grep -v ' drwx'


