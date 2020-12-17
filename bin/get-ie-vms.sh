#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
pushd /data/$USER/VirtualBox
mkdir ie-vm-downloads
cd ie-vm-downloads
pwd
grep -v '#' ~/bin/ie-vm-downloads.urllist | wget --input-file -
popd
