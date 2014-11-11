#!/usr/bin/env python
#-------------------------------------------------------------------------------
import os, sys, string
#-------------------------------------------------------------------------------

if len(sys.argv) < 3:
    sys.exit( "Usage: %s ENV_VAR path\n" % ( sys.argv[0] ) )

variable = sys.argv[1]
value    = sys.argv[2]

try:
    oldpath = os.environ[ variable ]
except KeyError:
    oldpath = ""

if ( oldpath != "" ):
    dirs = string.split( oldpath, ":" )
    while ( 1 ):
        try:
            idx = dirs.index( value )
        except ValueError:
            idx = -1

        if ( idx == -1 ): break

        del dirs[ idx ]
else:
    dirs = []

if ( dirs == [] ): newpath = ""
else:
    newpath = dirs[0]
    for idx in range(1, len(dirs)):
        newpath = newpath + ":" + dirs[idx]

print newpath

