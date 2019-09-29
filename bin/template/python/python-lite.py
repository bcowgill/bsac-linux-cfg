#!/usr/bin/env python

"""Documentaation for the program"""

import sys
import getopt
from traceback import print_exc, print_stack

import python_module


DEBUG=True

# Lambda Functions

# User defined local Functions

def g():
    print "g"
    print_stack() # useful for debugging to see how got here.

def f():
    g()

def print_exception(error):
    """Print an error or full exception trace if Debug is True"""
    if DEBUG:
        print "\n\n>>>>> Caught Error:"
        print_exc()
        print "\n\n"
    else:
        print "\n\n>>>>> Caught Error: %s\n" % error

def parse_cli():
    params = {}
    (opts, args) = getopt.gnu_getopt(sys.argv[1:], 'vx:y:h?i:', ['help', 'indent='])
    for opt in opts :
        key = opt[0]
        if key == '-i':
            key = '--index'
        if key in ('-h', '-?'):
            key = '--help'
        params[key] = opt[1]
    print "options:", opts
    return (params, args)

# Main program goes here
try:
    (opts, args) = parse_cli()
    print "opts:", opts
    print "args:", args
    print 'Hello, world!', 4/0
    f()
except Exception, error:
    print_exception(error)
else:
    # happens when there were no errors
    print "Success"
finally:
    # happens always unless os.abort() called
    print "Cleanup"
