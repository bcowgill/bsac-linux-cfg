#!/bin/bash

# only run some things as needed
DOIT=/bin/false
#DOIT=/bin/true

PJ42=/bin/false
DASH=/bin/true
KARMA=/bin/true

# always run these
RUNIT=/bin/true

TEST_DIR=$HOME/workspace/projects/infinity-plus-dashboard/test

if $DOIT; then

echo === Start up a local webserver for the play/ area
pushd ~/workspace/play/
   webserver.sh 9999 &
popd

fi # $RUNIT

if $PJ42; then

echo === Start up node app for project42 and an auto-build to restart it when files change and pass validation.

pushd ~/workspace/play/project42/

   [ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
   PORT=3333
   LOG=/tmp/$USER/nodeserver-$PORT.log
   [ -f $LOG ] && rm $LOG
   (echo Serving content from `pwd`; echo on url-port http://localhost:$PORT; echo logging to $LOG) | tee $LOG
   pushd scripts
      keep-it-up.sh ./run-pj42.sh >> $LOG 2>&1 &
   popd

if $RUNIT; then

   cd scripts
   LOG=/tmp/$USER/auto-build-project42.log
   [ -f $LOG ] && rm $LOG
   (echo Auto build in `pwd`; echo logging to $LOG) | tee $LOG
   auto-build.sh ./build-pj42.sh .. >> $LOG 2>&1 &

fi # $RUNIT

popd

fi # $PJ42

if $DOIT; then

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

fi # $DOIT

if $DASH; then

if $DOIT; then

echo === Start up local webserver for dashboard test plan output

#DIR=$TEST_DIR/campaign_details/out
DIR=$TEST_DIR/add_targeting_profile/out

[ ! -d $DIR ] && mkdir -p  $DIR
pushd $DIR
   webserver.sh 8888 &
popd

fi # $DOIT

if $KARMA; then

echo === Start up the karma runner server

pushd $TEST_DIR
   LOG=/tmp/$USER/karma-dashboard-9876.log
   [ -f $LOG ] && rm $LOG
   (echo Karma test runner server in `pwd`; echo logging to $LOG) | tee $LOG
   karma start >> $LOG 2>&1 &
popd

fi # $KARMA

if $DOIT; then

echo === Start up auto build for infinity plus dashboard
pushd ~/workspace/projects/infinity-plus-dashboard/setup
   LOG=/tmp/$USER/auto-build-dashboard.log
   [ -f $LOG ] && rm $LOG
   (echo Auto build in `pwd`; echo logging to $LOG) | tee $LOG
   auto-build.sh ./grunt-dash.sh .. >> $LOG 2>&1 &
   echo === Start up infinity plus dashboard dev instance
   ./start-app.sh
popd

fi # $DOIT

fi # $DASH

echo You need to start Charles before the browsers!

if $PJ42; then
echo konsole tabs pj42:
echo "1: pushd ~/workspace/play/project42; tail -f /tmp/brent/auto-build-project42.log"
echo "2: sudo -i"
echo "3: pushd ~/workspace/play/project42"
echo "4: dbinf"
echo "5: dbp42"
echo "6: pushd ~/workspace/play/project42; tail -f /tmp/brent/nodeserver-3333.log"
fi

if $DASH; then
echo konsole tabs dash:
echo "1: pushd ~/workspace/projects/infinity-plus-dashboard/; tail -f /tmp/brent/auto-build-dashboard.log"
echo "2: sudo -i"
echo "3: pushd ~/workspace/projects/infinity-plus-dashboard/"
echo "4: dbinf"
echo "5: dbp42"
echo "6: pushd ~/workspace/projects/review-infinity-plus-dashboard/"
fi

