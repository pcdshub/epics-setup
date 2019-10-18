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
export BASE_MODULE_VERSION=base-R3-14-12-4_1-1
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/extensions-R3-14-12

# Select EPICS V4 support modules (Not needed for BASE R7.0.0 or greater)

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/R3-14-12-4_1-1/modules

# Backward compatibility
export EPICS_BASE_VER=${BASE_MODULE_VERSION}
export EPICS_MODULES_VER=${BASE_MODULE_VERSION}
export EPICS_BASE_RELEASE=${EPICS_BASE}
export EPICS_MODULES_TOP=${EPICS_MODULES}

# PV Access not supported for base-R3-14-12
unset PVACCESSCPP_MODULE_VERSION
unset PVACCESSCPP

source ${SETUP_SITE_TOP}/generic-epics-setup.bash
