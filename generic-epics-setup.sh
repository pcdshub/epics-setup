# generic-epics-setup.sh
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

# Check that essential env path variables are defined and exist
if [ -z "$EPICS_SITE_TOP" ]; then
	echo "generic-epics-setup Error: EPICS_SITE_TOP undefined."
	return
fi
if [ ! -d ${EPICS_SITE_TOP} ]; then
	echo "generic-epics-setup Error EPICS_SITE_TOP does not exist: ${EPICS_SITE_TOP}"
	return
fi
if [ -z "$EPICS_BASE" ]; then
	echo "generic-epics-setup Error: EPICS_BASE undefined."
	return
fi
if [ ! -d ${EPICS_BASE} ]; then
	echo "generic-epics-setup Error EPICS_BASE does not exist: ${EPICS_BASE}"
	return
fi
if [ -z "$SETUP_SITE_TOP" ]; then
	echo "generic-epics-setup Error: SETUP_SITE_TOP undefined."
	return
fi
if [ ! -d ${SETUP_SITE_TOP} ]; then
	echo "generic-epics-setup Error SETUP_SITE_TOP does not exist: ${SETUP_SITE_TOP}"
	return
fi
if [ -z "$TOOLS_SITE_TOP" ]; then
	echo "generic-epics-setup Error: TOOLS_SITE_TOP undefined."
	return
fi
if [ ! -d ${TOOLS_SITE_TOP} ]; then
	echo "generic-epics-setup Error TOOLS_SITE_TOP does not exist: ${TOOLS_SITE_TOP}"
	return
fi

if [ -z "$EPICS_CA_AUTO_ADDR_LIST" ]; then
	# Setup the EPICS Channel Access environment
	source ${SETUP_SITE_TOP}/epics-ca-env.sh
fi

# get some functions for manipulating assorted env path variables
source ${SETUP_SITE_TOP}/pathmunge.sh

# Add eco, epics-release, netconfig and other common tools to path
# Note: This should probably go in fixed-epics-setup.sh
if [ -d ${TOOLS_SITE_TOP}/bin ]; then
	pathmunge ${TOOLS_SITE_TOP}/bin
fi
if [ -d ${TOOLS_SITE_TOP}/script ]; then
	pathmunge ${TOOLS_SITE_TOP}/script
fi

# Set EPICS_HOST_ARCH 
export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)

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
if [ -n "${EPICS_EXTENSIONS}" -a -d ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH} ]; then
	pathmunge ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}
fi
export PATH

# Set path to libraries provided by EPICS and its extensions (required by EPICS tools)
ldpathmunge ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
if [ -n "${EPICS_EXTENSIONS}" -a -d ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH} ]; then
	ldpathmunge ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
fi
export LD_LIBRARY_PATH

# EPICS V4 support (only needed pre EPICS 7)
if [ -d "$PVACCESS" ]; then
	# Clear out old V4 paths
	# Note: epicsenv-7.* should unset PVACCCES and purge
	# these paths before running generic-epics-setup.sh
	# so developers can switch from epics 7 to epics 3
	# and back as needed.
	pathpurge       "${EPICS_MODULES_TOP}/pvAccessCPP/*/bin/*"
	ldpathpurge     "${EPICS_MODULES_TOP}/*CPP/*/lib/*"
	pythonpathpurge "${EPICS_MODULES_TOP}/pvaPy/*/lib/python/*/*"

	# Add pvAccessCPP to PATH and LD_LIBRARY_PATH
	pathmunge   ${PVACCESS}/bin/${EPICS_HOST_ARCH}
	ldpathmunge ${PVACCESS}/lib/${EPICS_HOST_ARCH}
	export PATH

	# Add other V4 libs to LD_LIBRARY_PATH
	if  [        -d ${NORMATIVETYPES}/lib/${EPICS_HOST_ARCH} ]; then
		ldpathmunge ${NORMATIVETYPES}/lib/${EPICS_HOST_ARCH}
	fi
	if  [        -d ${PVDATA}/lib/${EPICS_HOST_ARCH} ]; then
		ldpathmunge ${PVDATA}/lib/${EPICS_HOST_ARCH}
	fi
	if  [        -d ${PVDATABASE}/lib/${EPICS_HOST_ARCH} ]; then
		ldpathmunge ${PVDATABASE}/lib/${EPICS_HOST_ARCH}
	fi
	export LD_LIBRARY_PATH
fi

if [ -d "${PVAPY}/lib/python/2.7/${EPICS_HOST_ARCH}" ]; then
	# Add pvaPy to PYTHONPATH
	pythonpathmunge ${PVAPY}/lib/python/2.7/${EPICS_HOST_ARCH}
	export PYTHONPATH
fi

if [ -n "${EPICS_EXTENSIONS}" ]; then
	# Set EDMLIBS, used in $EDMOBJECTS/edmObjects and edmPvObjects
	export EDMLIBS=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}

	# Set EDMHELPFILES
	if [ -d "$EPICS_EXTENSIONS/helpFiles" ]; then
		export EDMHELPFILES=$EPICS_EXTENSIONS/helpFiles
	else
		export EDMHELPFILES=$EPICS_EXTENSIONS/src/edm/helpFiles
	fi

	# The following could go to a one-time $EDMFILES/setup.sh
	export EDMWEBBROWSER=mozilla
	#export EDMDATAFILES=.
	export EDM=${TOOLS_SITE_TOP}/edm/display
	if [ -d ${TOOLS_SITE_TOP}/edm/config ]; then
		export EDMFILES=${TOOLS_SITE_TOP}/edm/config
	else
		export EDMFILES=${EPICS_SITE_TOP}/tools/edm/config
	fi
	export EDMCALC=${EDMFILES}/calc.list
	export EDMOBJECTS=$EDMFILES
	export EDMPVOBJECTS=$EDMFILES
	export EDMFILTERS=$EDMFILES
	export EDMUSERLIB=$EDMLIBS

	# The following setup is for vdct
	# WARNING: java-1.6.0-sun must be installed on the machine running vdct!!!
	if [ -e ${EPICS_EXTENSIONS}/javalib/VisualDCT.jar ]; then
		export VDCT_CLASSPATH="${EPICS_EXTENSIONS}/javalib/VisualDCT.jar"
	fi
fi
