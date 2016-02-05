#!/bin/bash
# run the karma tests with webstorm runner but on the console so you can grep the log output
# you may have to guess the port until the config file used matches the repo you are in.
# karma-webstorm.sh 9879 | grep locationHint | grep config://

REPO=$(basename `pwd`)
PORT=${1:-9876}

NODE_DIR=$HOME/.nvm/versions/node/v4.2.1
NODE=$NODE_DIR/bin/node
RUNNER=$HOME/Downloads/WebStorm-143.381.46/plugins/js-karma/js_reporter/karma-intellij/lib/intellijRunner.js
KARMA=$HOME/projects/$REPO/node_modules/karma
cmd="$NODE $RUNNER --karmaPackageDir=$KARMA --serverPort=$PORT --urlRoot=/"
echo $cmd
$cmd

