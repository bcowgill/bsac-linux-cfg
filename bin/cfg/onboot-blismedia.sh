#!/bin/bash

TEST_DIR=$HOME/workspace/projects/infinity-plus-dashboard/test

if /bin/false; then

echo === Start up a local webserver for the play/ area
pushd ~/workspace/play/
   webserver.sh 9999 &
popd

echo === Start up node app for project42 and an auto-build to restart it when files change and pass validation.
pushd ~/workspace/play/project42/
   [ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
   PORT=3333
   LOG=/tmp/$USER/nodeserver-$PORT.log
   [ -f $LOG ] && rm $LOG
   (echo Serving content from `pwd`; echo on url-port http://localhost:$PORT; echo logging to $LOG) | tee $LOG
   keep-it-up.sh npm start >> $LOG 2>&1 &

   cd scripts
   LOG=/tmp/$USER/auto-build-project42.log
   [ -f $LOG ] && rm $LOG
   (echo Auto build in `pwd`; echo logging to $LOG) | tee $LOG
   auto-build.sh ./build.sh .. >> $LOG 2>&1 &

popd

echo === Start up a local webserver for openlayers
pushd ~/workspace/play/open-layers/dist
   webserver.sh 9191 &
   echo === Start up auto build for openlayers
   cd ../scripts
   LOG=/tmp/$USER/auto-build-openlayers.log
   [ -f $LOG ] && rm $LOG
   (echo Auto build in `pwd`; echo logging to $LOG) | tee $LOG
   auto-build.sh ./build.sh >> $LOG 2>&1 &
popd

echo === Start up local webserver for test plan output
#DIR=$TEST_DIR/campaign_details/out
DIR=$TEST_DIR/add_targeting_profile/out

[ ! -d $DIR ] && mkdir -p  $DIR
pushd $DIR
   webserver.sh 8888 &
popd

fi # /bin/false

echo === Start up the karma runner server
pushd $TEST_DIR
   LOG=/tmp/$USER/karma-dashboard-9876.log
   [ -f $LOG ] && rm $LOG
   (echo Karma test runner server in `pwd`; echo logging to $LOG) | tee $LOG
   karma start >> $LOG 2>&1 &
popd

if /bin/false; then

echo === Start up auto build for infinity plus dashboard
pushd ~/workspace/projects/infinity-plus-dashboard/setup
   LOG=/tmp/$USER/auto-build-dashboard.log
   [ -f $LOG ] && rm $LOG
   (echo Auto build in `pwd`; echo logging to $LOG) | tee $LOG
   auto-build.sh ./grunt-dash.sh .. >> $LOG 2>&1 &
   echo === Start up infinity plus dashboard dev instance
   ./start-app.sh
popd


echo You need to start Charles before the browsers!

fi # /bin/false

