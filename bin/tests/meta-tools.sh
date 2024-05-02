#!/bin/bash
# list the meta-data tools which are still untested
pushd .. > /dev/null; for file in `git grep -l id3 *.pl *.sh`; do ff=`basename $file .pl`; ff=`basename $ff .sh`; [ -d tests/$ff ] || echo $ff; done; popd > /dev/null
