#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# turn off proxying to charles for commands like wget and curl
# See also proxy-to-charles.sh, chrome-proxy, nonpmproxy.sh
echo current _proxy environment variables
set | grep -i _proxy
echo turning off _proxy environment variables
export http_proxy=
export https_proxy=
export HTTPS_PROXY=
