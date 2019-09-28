#!/usr/bin/env python

import os
import sys

print "Demonstrate os / sys module features.\n"
print "sys.platform:", sys.platform
print "sys.byteorder:", sys.byteorder
print "sys.path:", sys.path

print "\nPython related:"
print "sys.version:", sys.version
print "sys.api_version:", sys.api_version
print "sys.hexversion %#x"% sys.hexversion
print sys.version_info
print "sys.executable:", sys.executable
print "sys.prefix:", sys.prefix
print "sys.exec_prefix:", sys.exec_prefix
print "sys.modules:", len(sys.modules)

print "\nCurrent script:"
command = sys.argv[0]
print "command:", command
print "sys.argv[1:]:", sys.argv[1:]

print "\nArchitecture:"
print "sys.maxint: %d %#x"% (sys.maxint, sys.maxint)
print "sys.maxsize: %d %#x"% (sys.maxsize, sys.maxsize)
print "sys.maxunicode: %d %#x" % (sys.maxunicode, sys.maxunicode)
print sys.long_info
print "sys.float_repr_style:", sys.float_repr_style
print sys.float_info

print "\nOS type related"
print "os.name", os.name
print "os.linesep", os.linesep
print "os.curdir", os.curdir
print "os.pardir", os.pardir
print "os.pathsep", os.pathsep
print "os.sep", os.sep
print "os.extsep", os.extsep
print "os.altsep", os.altsep
print "os.devnull", os.devnull

print "\nOS process related"
#print "os.getlogin()", os.getlogin()
print "os.getpid()", os.getpid()
print "os.getppid()", os.getppid()
print "os.getresuid()", os.getresuid()
print "os.getresgid()", os.getresgid()
print "os.getuid()", os.getuid()
print "os.getgid()", os.getgid()
print "os.geteuid()", os.geteuid()
print "os.getegid()", os.getegid()
print "os.getsid()", os.getsid(os.getpid())
print "os.getpgid()", os.getpgid(os.getpid())
print "os.getpgrp()", os.getpgrp()
print "os.getgroups()", os.getgroups()
print "os.getloadavg()", os.getloadavg()
print "os.getenv('PATH')", os.getenv('PATH')
print "os.environ", len(os.environ)

print "\nOS directory related"
print "os.getcwd()", os.getcwd()
print "os.getcwdu()", os.getcwdu()
print "os.access()", os.access('.', os.F_OK)
print "os.stat()", os.stat('.')
print "os.listdir()", os.listdir('.')

print "\nOS misc"
print "os.strerror():", os.strerror(os.EX_CANTCREAT)

def catch_me(type, error, traceback):
    print "\nUncaught Exception: <%s: %s>" % (type, error)
    print "traceback:", traceback
    print "sys.exc_info():", sys.exc_info()
    print "sys.getrefcount()", sys.getrefcount(error)
    print "sys.getsizeof()", sys.getsizeof(error)
    sys.exc_clear()

def exit_me():
    print "\nExit Handler invoked"

sys.exitfunc = exit_me
sys.excepthook = catch_me

print "\nSystem display:"
sys.displayhook("print this")
print "_:", _

print "\nException handling:"
try:
    22/0
except:
    print "Exception handled", sys.exc_info()

# Force an unhandled exception
print 34/0

print "\nAbort - hard exit"
os.abort() # a very hard exit (core dump) but we dont get here
