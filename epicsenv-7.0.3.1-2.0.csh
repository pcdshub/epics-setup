#!/bin/csh
#
# This script sets up a working EPICS environment for the
# specified base version.
# It gives access to caget, caput, edm, vdct and other EPICS tools,
#
# Copyright @2017 SLAC National Accelerator Laboratory
#

# Setup the common directory env variables
# Setup the common directory env variables
if (-f /reg/g/pcds/pyps/config/common_dirs.csh) then
	source   /reg/g/pcds/pyps/config/common_dirs.csh
else
    if (-f  /afs/slac/g/pcds/pyps/config/common_dirs.csh) then
	source   /afs/slac/g/pcds/pyps/config/common_dirs.csh
    endif
endif
setenv EPICS_SITE_TOP /reg/g/pcds/epics

# Select the EPICS base version and EPICS extensions version
setenv BASE_MODULE_VERSION R7.0.3.1-2.0
setenv EPICS_EXTENSIONS ${EPICS_SITE_TOP}/extensions/R0.2.0

setenv EPICS_BASE ${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
setenv EPICS_MODULES ${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules
setenv EPICS_MODULES_TOP $EPICS_MODULES

# MCB - Let's do this later.
## Unset any stale V4 support for versions prior to EPICS 7
#source ${SETUP_SITE_TOP}/pathmunge.sh
#unset PVACCESS
#unset PVAPY
#pathpurge       "${EPICS_MODULES_TOP}/pvAccessCPP/*/bin/*"
#ldpathpurge     "${EPICS_MODULES_TOP}/*CPP/*/lib/*"
#pythonpathpurge "${EPICS_MODULES_TOP}/pvaPy/*/lib/python/*/*"
source ${SETUP_SITE_TOP}/generic-epics-setup.csh
#
#if [ -n "${BASH_VERSION}" ]; then
#	# Run PCDS bash shortcuts
#	source ${SETUP_SITE_TOP}/pcds_shortcuts.sh
#fi
