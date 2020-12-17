#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
mkdir gnu-unicode-fonts
pushd gnu-unicode-fonts

wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont-8.0.01.ttf
wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_upper-8.0.01.ttf
wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_csur-8.0.01.ttf
wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_upper_csur-8.0.01.ttf
wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_sample-8.0.01.ttf

popd
