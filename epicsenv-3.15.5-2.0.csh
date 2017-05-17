#!/bin/csh
#
# This script setup a working EPICS environment. It gives access
# to EDM, VDCT and other development tools that are part of EPICS.
#
# Copyright @2012 SLAC National Accelerator Laboratory
# Copyright @2017 SLAC National Accelerator Laboratory
#
# Note: You can pre-define EPICS_HOST_ARCH to select which host
# architecture to use, or allow it to be auto-defined.
# For PCDS, we support setting EPICS_HOST_ARCH to linux-x86
# when running on a RHEL5 64 bit system, in order to run
# the RHEL5 32 bit version of the EPICS applications

# Setup the common directory env variables
if (-e /reg/g/pcds/pyps/config/common_dirs.sh) then
	source /reg/g/pcds/pyps/config/common_dirs.csh
else
	source /afs/slac/g/pcds/config/common_dirs.csh
endif
# We're changing EPICS_SITE_TOP as of 3.14.12.5
if ( -d /reg/g/pcds/epics ) then
	setenv EPICS_SITE_TOP /reg/g/pcds/epics
else
	setenv EPICS_SITE_TOP /afs/slac/g/pcds/epics
endif

# Setup the EPICS Channel Access environment
source ${SETUP_SITE_TOP}/epics-ca-env.csh

# get some functions for manipulating assorted env path variables
#source ${SETUP_SITE_TOP}/pathmunge.csh

setenv EPICS_TOOLS_SITE_TOP ${EPICS_SITE_TOP}

setenv BASE_MODULE_VERSION R3.15.5-2.0
setenv EPICS_BASE ${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
setenv EPICS_MODULES_TOP ${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules

setenv EPICS_EXTENSIONS ${EPICS_SITE_TOP}/extensions/R3.14.12

if ( "$?EPICS_HOST_ARCH" == "0" ) then
	setenv EPICS_HOST_ARCH `${EPICS_BASE}/startup/EpicsHostArch`
endif

# Default to linuxRT if startup/EpicsHostArch fails
if ( "$?EPICS_HOST_ARCH" == "0" ) then
	setenv EPICS_HOST_ARCH linuxRT-x86_64
endif

# If EPICS_HOST_ARCH is linux-x86_64 but not available, fall back to 32bit
if ( ! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH} ) then
	if ( "${EPICS_HOST_ARCH}" == "linux-x86_64" ) then
		# Try behaving as a 32bits system
		echo "WARNING: No linux-x86_64 binaries.  Falling back to linux-x86"
		EPICS_HOST_ARCH=linux-x86
	endif
endif
if ( ! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH} ) then
	echo "ERROR: No binaries in ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}."
endif

# Set path to utilities provided by EPICS and its extensions
setenv PATH ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:$PATH
setenv PATH ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:$PATH

# Set path to libraries provided by EPICS and its extensions (required by EPICS tools)
if ($?LD_LIBRARY_PATH == "0") then
    setenv LD_LIBRARY_PATH ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
else
    setenv LD_LIBRARY_PATH ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH
endif
setenv LD_LIBRARY_PATH ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH

# The following setup is for EDM
setenv EDMWEBBROWSER mozilla
setenv EDMCALC ${EPICS_EXTENSIONS}/svn_templates/edm/calc.list
setenv EDMDATAFILES .
setenv EDMFILES ${EPICS_EXTENSIONS}/svn_templates/edm
setenv EDMHELPFILES ${EPICS_EXTENSIONS}/helpFiles
setenv EDMUSERLIB ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
setenv EDMOBJECTS $EDMFILES
setenv EDMPVOBJECTS $EDMFILES
setenv EDMFILTERS $EDMFILES
setenv EDMLIBS $EDMUSERLIB

# The following setup is for vdct
# WARNING: java-1.6.0-sun must be installed on the machine running vdct!!!
if ( -e ${EPICS_EXTENSIONS}/javalib/VisualDCT.jar ) then
	setenv VDCT_CLASSPATH "${EPICS_EXTENSIONS}/javalib/VisualDCT.jar"
endif

#if ( -n "${BASH_VERSION}" ) then
#	# Run PCDS bash shortcuts
#	source ${SETUP_SITE_TOP}/pcds_shortcuts.csh
#endif

