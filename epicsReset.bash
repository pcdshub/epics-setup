#####################################################################
#                                                                   #
#  Title: epicsReset                                                #
#                                                                   #
#  Purpose: '.' this file to reset an old EPICS environment and     #
#           set your EPICS environment correctly                    #
#                                                                   #
#  History:                                                         #
#  17Jan2006 Debbie Rogind added export EPICS_HOST_ARCH=""          #
#  30Oct2007 Jingchen Zhou updated to support standalone production #
#            environment                                            #
#####################################################################
#
# Nullify old EPICS environment and export environment for LCLS EPICS.  
#
#-----------------------------------------------------------------------------
#
# Clear most environment variables that are not initially set in epicsSetup.
# Exceptions are PRINTER, PSPRINTER, PSFILENAME, and CVSEDITOR
# which should be set by the user in ~/.login before sourcing 
# epicsSetup or epicsReset.
#
# First clear and set PATH and MANPATH using SCS's environ script.
# HEPiX environment is not supported!
export HEP_ENV=""
export ENV=""
export ENVIRONMENT=""
export ETC=""
export CLUSTER_DIR=""
if [ -e /usr/local/bin/environ ]; then 
  eval `/usr/local/bin/environ /bin/bash -i0`
fi
# Now the rest.
export LD_LIBRARY_PATH=""
export CLASSPATH=""
export JAVAVER=""
#
export EPICS_DISPLAY_PATH=""
export EPICS_HOST_ARCH=""
export EDMDATAFILES=""
export EPICS_PR_LIST=""
export EPICS_EXTENSIONS=""
#
export MATLAB_ROOT=""
export MATLAB_VER=""
export LM_LICENSE_FILE=""
export MATLABPATH=""
export MATLABDATAFILES=""
#
export CMLOG_HOST=""
export CMLOG_PORT=""
export CMLOG_CONFIG=""
export CDEVTAGTABLE=""
#
export CVSROOT=""
export CVSIGNORE=""
#
# Set EPICS environment for AFS/NFS based development or NFS based 
# standalone produciton   
#
if [ -d /afs/slac/package ]; then 
	export LCLS_ROOT=/nfs/slac/g/lcls/build
else
	export LCLS_ROOT=/usr/local/lcls
fi

if [ -z $EPICS_BASE_TAG ]; then
	export EPICS_BASE_TAG=base-R3-14-8-2-lcls2
fi
if [ -z $EPICS_EXTENSIONS_VER ]; then
	export EPICS_EXTENSIONS_VER=R3-14-8-2
fi
. ${LCLS_ROOT}/epics/setup/epicsSetup.bash

