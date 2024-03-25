#!/bin/bash

NEXT=filter-web

./tests.sh
cd ../$NEXT
./test-chain.sh
