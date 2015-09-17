#!/bin/bash
# run the automated browser tests

suite=${1:-23489_Groups_Permissions_FE.txt}

# specify a variable override for browser, and selecte test #4 to run
# pybot -v browser:chrome -i 4 23489_Groups_Permissions_FE.txt
# you have to install chromedriver
# brew install chromedriver
# sudo apt-get install chromium-chromedriver
# https://sites.google.com/a/chromium

pushd ~/workspace/projects/qa/FeatureTest/suites/regression
	export PYTHONPATH=$HOME/projects/qa/FeatureTest/libraries
	export PATH=$PATH:$PYTHONPATH
#	echo $PYTHONPATH
#	echo $PATH

	pybot $suite
popd
