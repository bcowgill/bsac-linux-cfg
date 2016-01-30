#!/bin/bash
# clean and redo all the bower crap
rm -rf lib/bower_components/ app/bower_components
bower cache clean
bower install