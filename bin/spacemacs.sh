#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# launch spacemacs in its own home directory
HOME=~/spacemacs emacs \
	$* \
	&
