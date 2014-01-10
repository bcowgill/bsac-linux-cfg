#!/bin/bash
# start up the modeller quietly
pushd ~/modeller
truncate --size modeller.log
./modeller > /dev/null 2>&1 &
tail -f modeller.log
popd

