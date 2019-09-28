#!/usr/bin/env python

"""Documentaation for the program"""

from traceback import print_exc, print_stack
import python_module

DEBUG=False

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

# Main program goes here
try:
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
