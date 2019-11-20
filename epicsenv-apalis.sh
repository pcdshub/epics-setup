#!/bin/sh
#
# This script sets up a SLAC EPICS environment on an iSeg MPOD APALIS system.
# Must first mount needed NFS directories.
# See /reg/d/iocCommon/linuxRT/common/linuxRT_nfs.cmd
#
# Copyright @2018 SLAC National Accelerator Laboratory
#

# Setup the common directory env variables
if [ -e /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
fi

export EPICS_SITE_TOP=/opt/epics

# Select the EPICS base version and EPICS extensions version
export BASE_MODULE_VERSION=base-3.15.5
export EPICS_BASE=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}
export EPICS_MODULES=${EPICS_SITE_TOP}/modules

# Unsupported extensions 
unset EPICS_EXTENSIONS
unset PVACCESS_MODULE_VERSION
unset PVAPY_MODULE_VERSION
unset PVACCESS
unset PVAPY

source ${SETUP_SITE_TOP}/generic-epics-setup.sh

#if [ -n "${BASH_VERSION}" ]; then
#	# Run PCDS bash shortcuts
#	source ${SETUP_SITE_TOP}/pcds_shortcuts.sh
#fi
#
