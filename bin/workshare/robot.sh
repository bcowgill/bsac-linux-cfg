#!/bin/bash
# run the automated browser tests

suite=${1:-23489_Groups_Permissions_FE.txt}

if pip list | grep selenium2library | grep 1.7.3 ; then
    echo OK got the right selenium
else
    echo NOT OK got the wrong selenium
    sudo pip install robotframework-selenium2library==1.7.3
fi

# specify a variable override for browser, and select test #4 to run
# pybot -v browser:chrome -i 4 23489_Groups_Permissions_FE.txt
# you have to install chromedriver
# brew install chromedriver
# sudo apt-get install chromium-chromedriver
# https://sites.google.com/a/chromium

pushd ~/workspace/projects/qa/FeatureTest/suites/regression
	export PYTHONPATH=$HOME/projects/qa/FeatureTest/libraries
	export PATH=$PATH:$PYTHONPATH:/usr/lib/chromium-browser
#	echo $PYTHONPATH
#	echo $PATH

#	pybot $suite
	pybot $*
popd
