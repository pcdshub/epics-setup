#!/bin/sh
#
# This script sets up a working EPICS environment for the
# specified base version.
# It gives access to caget, caput, edm, vdct and other EPICS tools,
#
# Copyright @2017 SLAC National Accelerator Laboratory
#

# Setup the common directory env variables
source /afs/slac/g/lcls/epics/config/common_dirs.sh

# Select the EPICS base version and EPICS extensions version
export BASE_MODULE_VERSION=R7.0.1.2-DEV-0.0
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/R0.3.0

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules

# Backward compatibility
export EPICS_BASE_VER=${BASE_MODULE_VERSION}
export EPICS_MODULES_VER=${BASE_MODULE_VERSION}
export EPICS_BASE_RELEASE=${EPICS_BASE}
export EPICS_MODULES_TOP=${EPICS_MODULES}

unset PVACCESSCPP

source ${SETUP_SITE_TOP}/generic-epics-setup.bash

