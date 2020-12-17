#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# list apps running, less detail than what-apps.sh
pswide.sh | what-is-running.pl | grep ___ | egrep -v 'grep|cross-env'
