#!/bin/bash

NEXT=filter-images

./tests.sh
cd ../$NEXT
./test-chain.sh