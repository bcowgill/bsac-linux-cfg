#!/bin/bash
perl -ne 'my ($q, $Q) = (chr(39), chr(34)); s{(https?://[^\s$q$Q]+)}{print STDERR "$1\n"}xmsge;'

