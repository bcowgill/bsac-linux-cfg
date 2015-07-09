#!/bin/bash
# fire up programs when running in a gui
charles &
sleep 5
wstorm &
sleep 1
chromium-browser &
sleep 1
firefox &
sleep 1
skype &

pushd ~/projects/dealroom-ui
grunt serve:test
