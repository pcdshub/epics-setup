#!/bin/sh
#
# This script setup a working EPICS environment. It gives access
# to EDM, VDCT and other development tools that are part of EPICS.
#
# Copyright @2012 SLAC National Accelerator Laboratory
#
# Note: You can pre-define EPICS_HOST_ARCH to select which host
# architecture to use, or allow it to be auto-defined.
# For PCDS, we support setting EPICS_HOST_ARCH to linux-x86
# when running on a RHEL5 64 bit system, in order to run
# the RHEL5 32 bit version of the EPICS applications

# Setup the common directory env variables
if [ -e /reg/g/pcds/config/common_dirs.sh ]; then
	source /reg/g/pcds/config/common_dirs.sh
else
	source /afs/slac/g/pcds/config/common_dirs.sh
fi

# Setup the EPICS Channel Access environment
source ${SETUP_SITE_TOP}/epics-ca-env.sh

# get some functions for manipulating assorted env path variables
source ${SETUP_SITE_TOP}/pathmunge.sh

export EPICS_TOOLS_SITE_TOP=${EPICS_SITE_TOP}

export EPICS_BASE=${EPICS_SITE_TOP}/base/R3.14.12-0.4.0

export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/R3.14.12

if [ "$EPICS_HOST_ARCH" == "" ]; then
	if [ "$(which perl)" != "" ]; then
		export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch.pl)
	fi
fi

# Default to linuxRT if perl isn't installed or EpicsHostArch.pl fails
if [ "$EPICS_HOST_ARCH" == "" ]; then
	export EPICS_HOST_ARCH=linuxRT_glibc-x86_64
fi

# If EPICS_HOST_ARCH is linux-x86_64 but not available, fall back to 32bit
if [ ! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH} ]; then
	if [ "${EPICS_HOST_ARCH}" == "linux-x86_64" ]; then
		# Try behaving as a 32bits system
		echo "WARNING: No linux-x86_64 binaries.  Falling back to linux-x86"
		EPICS_HOST_ARCH=linux-x86
	fi
fi
if [ ! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH} ]; then
	echo "ERROR: No binaries in ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}."
fi

# Set path to utilities provided by EPICS and its extensions
pathmunge ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}
pathmunge ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}
export PATH

# Set path to libraries provided by EPICS and its extensions (required by EPICS tools)
ldpathmunge ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
ldpathmunge ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
export LD_LIBRARY_PATH

# The following setup is for EDM
export EDMWEBBROWSER=mozilla
export EDMCALC=${EPICS_EXTENSIONS}/svn_templates/edm/calc.list
export EDMDATAFILES=.
export EDMFILES=${EPICS_EXTENSIONS}/svn_templates/edm
export EDMHELPFILES=${EPICS_EXTENSIONS}/helpFiles
export EDMUSERLIB=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
export EDMOBJECTS=$EDMFILES
export EDMPVOBJECTS=$EDMFILES
export EDMFILTERS=$EDMFILES
export EDMLIBS=$EDMUSERLIB

# The following setup is for vdct
# WARNING: java-1.6.0-sun must be installed on the machine running vdct!!!
if [ -e ${EPICS_EXTENSIONS}/javalib/VisualDCT.jar ]; then
	export VDCT_CLASSPATH="${EPICS_EXTENSIONS}/javalib/VisualDCT.jar"
fi

if [ -n "${BASH_VERSION}" ]; then
	# Run PCDS bash shortcuts
	source ${SETUP_SITE_TOP}/pcds_shortcuts.sh
fi

