#-*-sh-*-
#
#   Title: generic-epics-setup.bash
# generic-epics-setup.bash
#
#  Purpose:
#   Source this file after setting or changing EPICS
#   versions via any of the following EPICS environment variables:
#       EPICS_BASE          - Path to top of base release
#       EPICS_EXTENSIONS    - Path to top of extensions release
#   These are needed for PVA prior to Base R7.* only
#       NORMATIVETYPES      - Path to top of PVA NormativeTypesCPP
#       PVACCESS            - Path to top of PVA PvAccessCPP release
#       PVDATA              - Path to top of PVA PvDataCPP release
#       PVAPY               - Path to top of PVA pvaPy release
#
if [ -z "$EPICS_SITE_TOP" ]; then
	echo "Warning: EPICS_SITE_TOP undefined."
fi

if [ "$SETUP_DEF_EPICS_ENV" != "NO" ]; then
	if [ -z "$EPICS_CA_SERVER_PORT" ]; then
		# Setup the EPICS Channel Access environment
		source ${SETUP_SITE_TOP}/envSet.bash
	fi
fi

# get some functions for manipulating assorted env path variables
source ${SETUP_SITE_TOP}/pathmunge.bash

# Set EPICS_HOST_ARCH
if [ "${BASE_MODULE_VERSION}" = "base-R3-14-12" ]; then
	export EPICS_HOST_ARCH=linux-x86
else
	export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)
fi

# Make sure we have a valid path to EPICS binaries
if [ ! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH} ]; then
	echo "ERROR: No binaries in ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}."
fi

# Clear out old EPICS paths
OLD_EPICS_PATHS=$(echo $PATH | sed -e "s/:/\n/g" | fgrep ${EPICS_SITE_TOP})
OLD_EPICS_LD_PATHS=$(echo $LD_LIBRARY_PATH | sed -e "s/:/\n/g" | fgrep ${EPICS_SITE_TOP})
OLD_MATLAB_PATHS=$(echo $MATLABPATH | sed -e "s/:/\n/g" | fgrep ${EPICS_SITE_TOP})
if [ -n "$OLD_EPICS_PATHS" ]; then
	pathpurge   $OLD_EPICS_PATHS
fi
if [ -n "$OLD_EPICS_LD_PATHS" ]; then
	ldpathpurge   $OLD_EPICS_LD_PATHS
fi
if [ -n "$OLD_MATLAB_PATHS" ]; then
	matlabpathpurge $OLD_MATLAB_PATHS
fi

# Set path to utilities provided by EPICS and its extensions
pathmunge ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}
if [ -d ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH} ]; then
	pathmunge ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}
fi
pathmunge $TOOLS_SITE_TOP/script
export PATH

# Set LD_LIBRARY_PATH to libraries provided by EPICS and its extensions (required by EPICS tools)
ldpathmunge ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
if [ -d ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH} ]; then
	ldpathmunge ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
fi
export LD_LIBRARY_PATH
export PYEPICS_LIBCA=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}/libca.so
export PYEPICS_LIBCOM=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}/libCom.so

# icdTemplates
export EPICS_MBA_TEMPLATE_TOP=$EPICS_MODULES_TOP/icdTemplates/icdTemplates-R1-2-2

# EPICS V4 support
if [ -d "$PVACCESSCPP" ]; then
	# Add pvAccessCPP to PATH
	pathmunge   ${PVACCESSCPP}/bin/${EPICS_HOST_ARCH}
	export PATH
fi

if [ -d "$PVAPY" ]; then
	# Add pvaPy to PYTHONPATH
	pythonpathmunge ${PVAPY}/lib/python/2.7/${EPICS_HOST_ARCH}
	export PYTHONPATH
fi

# The following setup is for EDM
if [ -z "$EDMDATAFILES" -o -z "$EDMOBJECTS" -o -z "$EDMPVOBJECTS" ]; then
	if [  -f  "$TOOLS_SITE_TOP/edm/config/setup.sh" ]; then
		source $TOOLS_SITE_TOP/edm/config/setup.sh
	fi
fi
# Update extensions related EDM env variables
if [ -e $EPICS_EXTENSIONS/helpFiles ]; then
	export EDMHELPFILES=$EPICS_EXTENSIONS/helpFiles
else
	export EDMHELPFILES=$EPICS_EXTENSIONS/src/edm/helpFiles
fi
export EDMLIBS=$EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH
export EDMUSERLIB=$EDMLIBS

# The following setup is for vdct
# WARNING: java-1.6.0-sun must be installed on the machine running vdct!!!
if [ -e ${EPICS_EXTENSIONS}/javalib/VisualDCT.jar ]; then
	export VDCT_CLASSPATH="${EPICS_EXTENSIONS}/javalib/VisualDCT.jar"
fi

# Fix MATLABPATH
matlabpathmunge $EPICS_EXTENSIONS/lib/$EPICS_HOST_ARCH
matlabpathmunge $EPICS_EXTENSIONS/bin/$EPICS_HOST_ARCH/labca

