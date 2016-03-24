#!/bin/bash
# turn off npm proxy configuration

npm config delete proxy
npm config delete https-proxy
npm config delete strict-ssl
