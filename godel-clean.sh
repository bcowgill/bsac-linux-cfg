#!/bin/bash
# run godel really clean 
echo Stop your runtime now!
echo Going to delete your /tmp/ontology/system and output you will lose stuff you have not pulled from the runtime!
read WAIT
rm -rf /tmp/ontology/output/ /tmp/ontology/system/
mkdir /tmp/ontology/output/ /tmp/ontology/system
find /tmp/ontology/
ps -ef | grep 8085
touch /tmp/ontology/godel-clean.timestamp
echo Go ahead and build Godel clean now in Eclipse then come back here to apply config fragments
read WAIT
apply-config-localhost.sh
echo Go ahead and deploy your resources to the runtime now.
echo To see what files changed in the build:
echo find ~/workspace/trunk -newer /tmp/ontology/godel-clean.timestamp

