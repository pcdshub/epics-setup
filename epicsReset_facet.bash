#####################################################################
#                                                                   #
#  Title: epicsReset_facet                                          #
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
#  02Nov2010 Jingchen Zhou cloned from LCLS epicsReset.bash 
#  06Nov2013 Jingchen Zhou remove CMLOG
#  15Jul2014 Jingchen Zhou make EPICS R3-14-12 as the default      
#####################################################################
#
# Nullify old EPICS environment and export environment for FACET EPICS.  
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
#export CLASSPATH=""
export JAVA_HOME=""
#
export EPICS_DISPLAY_PATH=""
export EPICS_HOST_ARCH=""
export EDMDATAFILES=""
export EPICS_PR_LIST=""
export EPICS_BASE_RELEASE=""
export EPICS_EXTENSIONS=""
export EPICS_MODULES_TOP=""
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
# Set EPICS environment for AFS based development or NFS based 
# standalone production   
#
if [ -d /afs/slac/g/facet ]; then 
	export FACET_ROOT=/afs/slac/g/facet
else
	export FACET_ROOT=/usr/local/facet
fi

if [ -z $EPICS_BASE_VER ]; then
	export EPICS_BASE_VER=base-R3-14-12
fi
if [ -z $EPICS_EXTENSIONS_VER ]; then
	export EPICS_EXTENSIONS_VER=R3-14-12
fi
if [ -z $EPICS_MODULES_VER ]; then
        export EPICS_MODULES_VER=R3-14-12
fi

if [ -z $JAVAVER ]; then
        export JAVAVER=1.7.0_05
fi

. ${FACET_ROOT}/epics/setup/epicsSetup_facet.bash

