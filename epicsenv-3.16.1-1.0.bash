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
export BASE_MODULE_VERSION=R3.16.1-1.0
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/extensions-R3.15.5

# Select EPICS V4 support modules (Not needed for BASE R7.0.0 or greater)
export PVACCESS_MODULE_VERSION=R6.0.0-0.3.0
export PVDATABASE_MODULE_VERSION=R4.3.0-0.0.3
export PVDATA_MODULE_VERSION=R7.0.0-0.0.1
export NORMATIVETYPES_MODULE_VERSION=R5.2.0-0.0.1

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules

# Backward compatibility
export EPICS_BASE_VER=${BASE_MODULE_VERSION}
export EPICS_MODULES_VER=${BASE_MODULE_VERSION}
export EPICS_BASE_RELEASE=${EPICS_BASE}
export EPICS_MODULES_TOP=${EPICS_MODULES}

export PVACCESS=${EPICS_MODULES}/pvAccessCPP/${PVACCESS_MODULE_VERSION}
export PVDATA=${EPICS_MODULES}/pvDataCPP/${PVDATA_MODULE_VERSION}
export PVDATABASE=${EPICS_MODULES}/pvDatabaseCPP/${PVDATABASE_MODULE_VERSION}
export NORMATIVETYPES=${EPICS_MODULES}/normativeTypesCPP/${NORMATIVETYPES_MODULE_VERSION}

source ${SETUP_SITE_TOP}/generic-epics-setup.bash

