#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# To debug problems with karma:
# npm install -g karma karma-chrome-launcher karma-chai karma-mocha karma-phantomjs-launcher karma-requirejs karma-sinon karma-sinon-chai
# (check package.json for most recent list of karma plugins)
#
# Then go to the chrome browser and click the Debug button.

karma --log-level debug --browsers Chrome --single-run false start $*
