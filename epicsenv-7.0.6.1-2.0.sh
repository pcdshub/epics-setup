#!/bin/sh
#
# This script sets up a working EPICS environment for the
# specified base version.
# It gives access to caget, caput, edm, vdct and other EPICS tools,
#
# Copyright @2017 SLAC National Accelerator Laboratory
#

# Setup the common directory env variables
if [ -e /cds/group/pcds/pyps/config/common_dirs.sh ]; then
	source /cds/group/pcds/pyps/config/common_dirs.sh
else
	source /afs/slac/g/pcds/config/common_dirs.sh
fi

# Using new weka filesystem as of EPICS 7.0.6.1-2.0
export CONFIG_SITE_TOP=/cds/group/pcds/pyps/config
export DATA_SITE_TOP=/cds/data
export EPICS_SITE_TOP=/cds/group/pcds/epics
export FACILITY_ROOT=/cds/group/pcds
export GW_SITE_TOP=/cds/group/pcds/gateway
export IOC_COMMON=/cds/data/iocCommon
export IOC_DATA=/cds/data/iocData
export PACKAGE_SITE_TOP=/cds/group/pcds/package
export PSPKG_ROOT=/cds/group/pcds/pkg_mgr
export PYAPPS_SITE_TOP=/cds/group/pcds/controls
export PYPS_SITE_TOP=/cds/group/pcds/pyps
export SETUP_SITE_TOP=/cds/group/pcds/setup
#export TOOLS_SITE_TOP=/cds/sw/tools

# Select the EPICS base version and EPICS extensions version
export BASE_MODULE_VERSION=R7.0.6.1-2.0
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/R0.2.0

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules

# Unset any stale V4 support for versions prior to EPICS 7
source ${SETUP_SITE_TOP}/pathmunge.sh
unset PVACCESS
unset PVAPY
pathpurge       "${EPICS_MODULES_TOP}/pvAccessCPP/*/bin/*"
ldpathpurge     "${EPICS_MODULES_TOP}/*CPP/*/lib/*"
pythonpathpurge "${EPICS_MODULES_TOP}/pvaPy/*/lib/python/*/*"
source ${SETUP_SITE_TOP}/generic-epics-setup.sh

if [ -n "${BASH_VERSION}" ]; then
	# Run PCDS bash shortcuts
	source ${SETUP_SITE_TOP}/pcds_shortcuts.sh
fi

