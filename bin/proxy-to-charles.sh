#!/bin/bash
# turn on proxying to charles for commands like wget and curl
echo current _proxy environment variables
set | grep -i _proxy

echo setting _proxy environment variables for Charles Debugging Proxy
export http_proxy=http://localhost:58008
export https_proxy=https://localhost:58008
export HTTPS_PROXY=$https_proxy

echo new _proxy environment variables
set | grep -i _proxy
