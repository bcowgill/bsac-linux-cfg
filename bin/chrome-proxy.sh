#!/bin/bash
# Start chromium browser with proxying on for use with Charles

# --incognito URL
chromium-browser --proxy-server="https=localhost:58008;http=localhost:58008" &

