#-*-sh-*-
#
#   Title: fixed-epics-setup.bash
#
#  Purpose:
#   Source this file once from .bash_profile on login to
#   set your fixed EPICS environment variables.
#
#   NOTE: This file should not set any version specific paths.
#   Instead, source generic-epics-setup.bash after specifying
#   EPICS versions to setup version env variables.
#
umask 002
HOSTNAME=`hostname`

#
# Set up FACILITY_ROOT
#
export FACILITY_ROOT=/reg/g/pcds

#
# Set up the rest of environment variables based on above root variables 
#
export RTEMS=/reg/g/pcds/package/rtems
export TOOLS=/reg/common/tools
export EPICS_TOP=/reg/g/pcds/epics
export EPICS_SETUP=/reg/g/pcds/setup

# IOC
export EPICS_IOC_TOP=$EPICS_TOP/ioc

#
# For running IOCs and iocConsole
#
export IOC_COMMON=/reg/d/iocCommon
export IOC_DATA=/reg/d/iocData

#
# Setup remaining EPICS CA environment variables
#
if [ -z "$EPICS_CA_AUTO_ADDR_LIST" ]; then
	# Setup the EPICS Channel Access environment
	source ${SETUP_SITE_TOP}/epics-ca-env.sh
fi

# get some functions for manipulating assorted env path variables
source ${SETUP_SITE_TOP}/pathmunge.sh

# Add eco, epics-release, netconfig and other common tools to path
if [       -d ${TOOLS_SITE_TOP}/bin ]; then
	pathmunge ${TOOLS_SITE_TOP}/bin
fi
if [       -d ${TOOLS_SITE_TOP}/script ]; then
	pathmunge ${TOOLS_SITE_TOP}/script
fi
if [       -d ${TOOLS_SITE_TOP}/edm/script ]; then
	pathmunge ${TOOLS_SITE_TOP}/edm/script
fi

# Add $TOOLS/AlarmConfigTop/SCRIPT  
if [       -d ${TOOLS_SITE_TOP}/AlarmConfigsTop/SCRIPT ]; then
	pathmunge ${TOOLS_SITE_TOP}/AlarmConfigsTop/SCRIPT
fi

#
# Add X to PATH
#
if [       -d /usr/X11R6/bin ]; then
	pathmunge /usr/X11R6/bin 
fi

