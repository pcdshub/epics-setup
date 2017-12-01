#!/bin/sh
#
# This script setup a working EPICS environment. It gives access
# to EDM, VDCT and other development tools that are part of EPICS.
#
# Copyright @2012 SLAC National Accelerator Laboratory
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
export EPICS_EXTENSIONS=${EPICS_SITE_TOP}/extensions/R3.14.12

# TODO: The rest of this is generic w/ regard to base and extensions versions
# so we should push it into a shared script, or maybe one for base and
# one for extensions

# Setup the EPICS Channel Access environment
source ${SETUP_SITE_TOP}/epics-ca-env.sh

# get some functions for manipulating assorted env path variables
source ${SETUP_SITE_TOP}/pathmunge.sh

export EPICS_TOOLS_SITE_TOP=${EPICS_SITE_TOP}

export EPICS_BASE=${EPICS_SITE_TOP}/base/${BASE_MODULE_VERSION}
export EPICS_BASE_RELEASE=${EPICS_BASE}
export EPICS_MODULES_TOP=${EPICS_SITE_TOP}/${BASE_MODULE_VERSION}/modules

if [ "$EPICS_HOST_ARCH" == "" ]; then
	export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)
fi

# Make sure we have a valid path to EPICS binaries
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

