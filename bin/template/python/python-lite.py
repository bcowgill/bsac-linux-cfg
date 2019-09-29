#!/usr/bin/env python

"""Documentaation for the program"""

import sys
import getopt
from traceback import print_exc, print_stack

import python_module


DEBUG=False

exit_code=0

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

def usage(option, message):
    print "Argument error: %s\n"% (message)
    print "\
usage: %s [-x number] [-y number] [-i or --indent number] [-v] [-? -h or --help]\
\n\
\n-x   specifies the X axis coordinate. default 0.\
\n-y   specifies the Y axis coordinate. default 0.\
\n-i   specifies the indentation amount. default 0.\
\n-v   verbose flag.\
\n-h   provide detailed program help.\
\n\
\nThis program just demonstrates a number of commonly needed features of a comand line command written in python.\
\n"% (sys.argv[0])

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
    if len(opts):
        print "options:", opts
    return (params, args)

# Main program goes here
try:
    (opts, args) = parse_cli()
    if len(opts):
        print "opts:", opts
    if len(args):
        print "args:", args
    print 'Hello, world!', 4/0
    f()
except getopt.GetoptError, error:
    usage(error.opt, error.msg)
    exit_code=1
except Exception, error:
    print_exception(error)
    exit_code=2
else:
    # happens when there were no errors
    print "Success"
finally:
    # happens always unless os.abort() called
    print "Cleanup"
    sys.exit(exit_code)
