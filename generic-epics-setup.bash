# generic-epics-setup.bash
if [ -z "$EPICS_SITE_TOP" ]; then
	echo "Warning: EPICS_SITE_TOP undefined."
fi

if [ -z "$EPICS_CA_AUTO_ADDR_LIST" ]; then
	# Setup the EPICS Channel Access environment
	source ${SETUP_SITE_TOP}/envSet.bash
fi

# get some functions for manipulating assorted env path variables
source ${SETUP_SITE_TOP}/pathmunge.bash

# Make sure we have a valid path to EPICS binaries
export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)
if [ ! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH} ]; then
	echo "ERROR: No binaries in ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}."
fi

# Clear out old EPICS paths
pathpurge "${EPICS_SITE_TOP}/base/*/bin/*"
pathpurge "${EPICS_SITE_TOP}/extensions/*/bin/*"

# Set path to utilities provided by EPICS and its extensions
pathmunge ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}
if [ -d ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH} ]; then
	pathmunge ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}
fi
export PATH

# Set path to libraries provided by EPICS and its extensions (required by EPICS tools)
ldpathmunge ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
if [ -d ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH} ]; then
	ldpathmunge ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
fi
export LD_LIBRARY_PATH

# EPICS V4 support
if [ -d "$PVACCESS" ]; then
	# Clear out old V4 paths
	pathpurge "${EPICS_MODULES_TOP}/pvAccessCPP/*/bin/*"
	ldpathpurge "${EPICS_MODULES_TOP}/*CPP/*/lib/*"

	# Add pvAccessCPP to PATH and LD_LIBRARY_PATH
	pathmunge   ${PVACCESS}/bin/${EPICS_HOST_ARCH}
	ldpathmunge ${PVACCESS}/lib/${EPICS_HOST_ARCH}
	export PATH

	# Add other V4 libs to LD_LIBRARY_PATH
	ldpathmunge ${NORMATIVETYPES}/lib/${EPICS_HOST_ARCH}
	ldpathmunge ${PVDATA}/lib/${EPICS_HOST_ARCH}
	#ldpathmunge ${PVDATABASE}/lib/${EPICS_HOST_ARCH}
	export LD_LIBRARY_PATH
fi

if [ -d "$PVAPY" ]; then
	# Add pvaPy to PYTHONPATH
	pythonpathpurge "${EPICS_MODULES_TOP}/pvaPy/*/lib/python/*/*"
	pythonpathmunge ${PVAPY}/lib/python/2.7/${EPICS_HOST_ARCH}
	export PYTHONPATH
fi

# The following setup is for EDM
export EDMWEBBROWSER=firefox
#export EDMDATAFILES=.
export EDM=${TOOLS_SITE_TOP}/edm/display
export EDMFILES=${TOOLS_SITE_TOP}/edm/config
export EDMCALC=${EDMFILES}/calc.list
export EDMOBJECTS=$EDMFILES
export EDMPVOBJECTS=$EDMFILES
export EDMFILTERS=$EDMFILES
#export EDMHELPFILES=${EPICS_EXTENSIONS}/helpFiles
export EDMHELPFILES=$EPICS_EXTENSIONS/src/edm/helpFiles
export EDMLIBS=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
export EDMUSERLIB=${EDMLIBS}

# The following setup is for vdct
# WARNING: java-1.6.0-sun must be installed on the machine running vdct!!!
if [ -e ${EPICS_EXTENSIONS}/javalib/VisualDCT.jar ]; then
	export VDCT_CLASSPATH="${EPICS_EXTENSIONS}/javalib/VisualDCT.jar"
fi
