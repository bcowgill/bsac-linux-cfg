#!/bin/bash
# run the karma tests with webstorm runner but on the console so you can grep the log output
NODE_DIR=$HOME/.nvm/versions/node/v4.2.1
NODE=$NODE_DIR/bin/node
RUNNER=$HOME/Downloads/WebStorm-143.381.46/plugins/js-karma/js_reporter/karma-intellij/lib/intellijRunner.js
KARMA=$NODE_DIR/lib/node_modules/karma
$NODE $RUNNER --karmaPackageDir=$KARMA --serverPort=9876 --urlRoot=/
