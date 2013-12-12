#!/bin/bash
# save some stuff to dropbox for work at home
pushd ~/workspace
tar cvzf work-visualise.tgz play/d3 charles-config/
cp work-visualise.tgz ~/Dropbox/WorkSafe/work-visualise.tgz
popd

