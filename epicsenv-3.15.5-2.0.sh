#!/bin/sh
#
# This script sets up a working EPICS environment for the
# specified base version.
# It gives access to caget, caput, edm, vdct and other EPICS tools,
#
# Copyright @2017 SLAC National Accelerator Laboratory
#

# Setup the common directory env variables
if [ -e /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
else
	source /afs/slac/g/pcds/config/common_dirs.sh
fi
# We're changing EPICS_SITE_TOP as of 3.14.12.5
if [ -d /reg/g/pcds/epics ]; then
	export EPICS_SITE_TOP=/reg/g/pcds/epics
else
	export EPICS_SITE_TOP=/afs/slac/g/pcds/epics
fi

# Select the EPICS base version and EPICS extensions version
export BASE_MODULE_VERSION=R3.15.5-2.0
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/R0.2.0

# Select EPICS V4 support modules (Not needed for BASE R7.0.0 or greater)
export PVACCESS_MODULE_VERSION=R6.1.0-0.1.0
export PVAPY_MODULE_VERSION=R0.7.0-0.0.1
#export PVDATABASE_MODULE_VERSION=R4.3.0-0.0.3
#export PVDATA_MODULE_VERSION=R7.0.0-0.0.1
#export NORMATIVETYPES_MODULE_VERSION=R5.2.0-0.0.1

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules
export PVACCESS=${EPICS_MODULES}/pvAccessCPP/${PVACCESS_MODULE_VERSION}
export PVAPY=${EPICS_MODULES}/pvaPy/${PVAPY_MODULE_VERSION}

# Backward compatibility
#export EPICS_BASE_RELEASE=${EPICS_BASE}
#export EPICS_MODULES_TOP=${EPICS_MODULES}

source ${SETUP_SITE_TOP}/generic-epics-setup.sh

