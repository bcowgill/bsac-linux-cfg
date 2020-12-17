#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# turn on proxying to charles for commands like wget and curl
# See also proxy-off.sh, chrome-proxy, nonpmproxy.sh
echo current _proxy environment variables
set | grep -i _proxy

echo setting _proxy environment variables for Charles Debugging Proxy
export http_proxy=http://localhost:58008
export https_proxy=https://localhost:58008
export HTTPS_PROXY=$https_proxy

echo new _proxy environment variables
set | grep -i _proxy
