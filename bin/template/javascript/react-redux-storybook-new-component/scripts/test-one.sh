#!/bin/bash
#TEST_DEBUG=1 jest --config specs/jest.config.json --forceExit --verbose --debug --testRegex $1
TEST_DEBUG=1 jest --config specs/jest.config.json --forceExit --debug --testRegex $1
