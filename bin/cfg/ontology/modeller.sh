#!/bin/bash
# start up the modeller quietly
pushd ~/modeller
truncate --size modeller.log
./modeller > /dev/null 2>&1 &
#tailmodeller.sh
tail -f modeller.log | show-java-log-errors.pl 
popd

