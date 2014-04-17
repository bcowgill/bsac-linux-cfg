#!/bin/bash
pushd /data/$USER/VirtualBox
mkdir ie-vm-downloads
cd ie-vm-downloads
pwd
wget --input-file ~/bin/ie-vm-downloads.urllist
popd
