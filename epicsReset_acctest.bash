#####################################################################
#                                                                   #
#  Title: epicsReset_testacc                                                #
#                                                                   #
#  Purpose: '.' this file to reset an old EPICS environment and     #
#           set your EPICS environment correctly                    #
#                                                                   #
#  History:                                                         #
#  17Jan2006 Debbie Rogind added export EPICS_HOST_ARCH=""          #
#  30Oct2007 Jingchen Zhou updated to support standalone production #
#            environment                                            #
#  21Apr2008 Jingchen Zhou updated to support AFS based development #
#            environment                                            #
#  17Nov2009 Jingchen Zhou removed /usr/local/bin/environ provided  #
#                          SCCS                                     #
#  14Dec2009 Jingchen Zhou removed reset LD_LIBRARY_PATH            #
#  01Nov2011 Jingchen Zhou updated for ACCTEST
#  05Nov2011 Jingchen Zhou added EPICS_VER to build up any EPICS 
#                          version related environment variable
#  11Mar2013 Jingchen Zhou upgraded java to 1.7  
#  06Nov2013 Jingchen Zhou remove CMLOG
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
# Now the rest.
#export LD_LIBRARY_PATH=""
export CLASSPATH=""
export JAVA_HOME=""
#
export EPICS_DISPLAY_PATH=""
export EPICS_HOST_ARCH=""
export EDMDATAFILES=""
export EPICS_PR_LIST=""
export EPICS_BASE_RELEASE=""
export EPICS_EXTENSIONS=""
#
export MATLAB_ROOT=""
export MATLAB_VER=""
export LM_LICENSE_FILE=""
export MATLABPATH=""
export MATLABDATAFILES=""
#
#export CMLOG_HOST=""
#export CMLOG_PORT=""
#export CMLOG_CONFIG=""
#export CDEVTAGTABLE=""
#
# Set EPICS environment for AFS based production environment for ACCTEST
#
if [ -d /afs/slac/g/acctest ]; then 
	export ACCTEST_ROOT=/afs/slac/g/acctest
fi

export EPICS_VER=R3-14-12

export EPICS_BASE_VER=base-${EPICS_VER}
export EPICS_EXTENSIONS_VER=${EPICS_VER}
export EPICS_MODULES_VER=${EPICS_VER}
export EPICS_IOC_VER=${EPICS_VER}

if [ -z $JAVAVER ]; then
        export JAVAVER=1.7.0_01
fi

. ${ACCTEST_ROOT}/epics/setup/epicsSetup_acctest.bash

