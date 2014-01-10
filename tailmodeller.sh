#!/bin/bash
# tail the modeller log file with appropriate colour scheme
multitail -du --basename -m 1000 --no-repeat --follow-all -cS log4j ~/modeller/modeller.log
