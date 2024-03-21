#!/bin/bash
echo Environment settings which control the build or test suite configuration:
git grep process.env. | perl -pne 's{process\.env\.\w+}{\n$1\n}xmsg' | grep process.env | sort | uniq
