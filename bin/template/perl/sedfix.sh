#!/bin/bash
# examples of using sed to search and replace content

sed -i 's#lloyds_url#lloydsbank-lp-'${appname}'.lbg.eu-gb.mybluemix.net#g' nginx.conf
sed -i 's#bos_url#bankofscotland-bp-'${appname}'.lbg.eu-gb.mybluemix.net#g' nginx.conf
sed -i 's#hfax_url#halifax-online-hp-'${appname}'.lbg.eu-gb.mybluemix.net#g' nginx.conf

find ./card-control/cwa -type f -name '0.bundle.js' -exec sed -i 's#/personal/retail/card-control-api/browser#/card-control#g' {} \;
find ./card-control/cwa -type f -name 'main.*.js' -exec sed -i 's#/personal/retail/card-control-api/browser#/card-control#g' {} \;
