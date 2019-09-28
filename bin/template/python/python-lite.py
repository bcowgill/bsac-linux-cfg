#!/usr/bin/env python

"""Documentaation for the program"""

from traceback import print_exc as print_exception, print_stack
import python_module

# Lambda Functions

# User defined local Functions

# python statements

def g():
    print "g"
    print_stack() # useful for debugging to see how got here.

def f():
    g()

try:
    f()
    print 'Hello, world!', 4/0
except Exception:
    print "\n\n>>>>> Caught Error:"
    print_exception()
    print "\n\n"
else:
    # happens when there were no errors
    print "Success"
finally:
    # happens always unless os.abort() called
    print "Cleanup"
