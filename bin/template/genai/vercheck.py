#!/usr/bin/env python3
import sys
import re

def python_version():
    match = re.search(r'\d+(\.\d+)?', sys.version)
    numeric = '0'
    if match:
        numeric = match.group()
    return float(numeric)

version = sys.version
print("Python Version: " + version)

if python_version() >= 3:
    print("version 3+")
else:
    print("version <=2")
