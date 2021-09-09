#!/bin/bash

PROVE=$1
./test-json-minus.sh $PROVE
./test-json-plus.sh $PROVE
