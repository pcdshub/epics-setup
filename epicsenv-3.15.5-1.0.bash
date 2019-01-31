#!/bin/sh
#
# This script sets up a working EPICS environment for the
# specified base version.
# It gives access to caget, caput, edm, vdct and other EPICS tools,
#
# Copyright @2017 SLAC National Accelerator Laboratory
#

# Setup the common directory env variables
if [    -f /afs/slac/g/lcls/epics/config/common_dirs.sh ]; then
	source /afs/slac/g/lcls/epics/config/common_dirs.sh
elif [  -f ${FACILITY_ROOT}/epics/config/common_dirs.sh ]; then
	source ${FACILITY_ROOT}/epics/config/common_dirs.sh
elif [  -f /usr/local/lcls/epics/config/common_dirs.sh ]; then
	source /usr/local/lcls/epics/config/common_dirs.sh
fi

# Select the EPICS base version and EPICS extensions version
export BASE_MODULE_VERSION=R3.15.5-1.0
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/R0.4.0

# Select EPICS V4 support modules (Not needed for BASE R7.0.0 or greater)
export PVACCESSCPP_MODULE_VERSION=R6.1.0-0.1.0

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules

# Backward compatibility
export EPICS_BASE_VER=${BASE_MODULE_VERSION}
export EPICS_MODULES_VER=${BASE_MODULE_VERSION}
export EPICS_BASE_RELEASE=${EPICS_BASE}
export EPICS_MODULES_TOP=${EPICS_MODULES}

export PVACCESSCPP=${EPICS_MODULES}/pvAccessCPP/${PVACCESSCPP_MODULE_VERSION}

source ${SETUP_SITE_TOP}/generic-epics-setup.bash

