#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

sudo /etc/init.d/networking stop
sudo /etc/init.d/network-manager stop
sudo /etc/init.d/networking start
sudo /etc/init.d/network-manager start
