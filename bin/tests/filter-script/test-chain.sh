#!/bin/bash

NEXT=filter-sounds

./tests.sh
cd ../$NEXT
./test-chain.sh
