#!/bin/bash
# scan for unimplemented conditions of satisfaction tests

# Example what we are scanning
#./test/spec/dialogs/views/BodyBulkDownloadView.spec.js:79:            it.skip('should publish a Mixpannel Events when click download Bible Version with Include Index', function () {

scan-code.sh | grep skip | perl -pne 's{\A.+?:\d+:\s+it\.skip\(\s*.(.+?)}{$1}xms'
#scan-code.sh | grep skip | perl -pne 's{\A.+?:\d+:\s+it\.skip\(.(.+?).,\s+function\(.*\)\s+\{}{$1}xms'
