#!/bin/bash

NEXT=filter-configs

./tests.sh
cd ../$NEXT
./test-chain.sh
