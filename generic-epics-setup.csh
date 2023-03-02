# generic-epics-setup.csh
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
if ($?EPICS_SITE_TOP == 0) then
	echo "generic-epics-setup Error: EPICS_SITE_TOP undefined."
	return -1
endif
if ($?EPICS_BASE == 0) then
	echo "generic-epics-setup Error: EPICS_BASE undefined."
	return -1
endif
if ($?SETUP_SITE_TOP == 0) then
	echo "generic-epics-setup Error: SETUP_SITE_TOP undefined."
	return -1
endif
if ($?TOOLS_SITE_TOP == 0) then
	echo "generic-epics-setup Error: TOOLS_SITE_TOP undefined."
	return -1
endif

if ($?EPICS_CA_AUTO_ADDR_LIST == 0) then
	# Setup the EPICS Channel Access environment
	source ${SETUP_SITE_TOP}/epics-ca-env.csh
endif

# Add eco, epics-release, netconfig and other common tools to path
# Note: This should probably go in fixed-epics-setup.sh
if (-d ${TOOLS_SITE_TOP}/bin) then
	setenv PATH ${TOOLS_SITE_TOP}/bin:$PATH
endif
if (-d ${TOOLS_SITE_TOP}/script) then
	setenv PATH ${TOOLS_SITE_TOP}/script:$PATH
endif

# Set EPICS_HOST_ARCH 
setenv EPICS_HOST_ARCH `${EPICS_BASE}/startup/EpicsHostArch`

# Make sure we have a valid path to EPICS binaries
if (! -d ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}) then
	echo "ERROR: No binaries in ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}."
endif

# Set path to utilities provided by EPICS and its extensions
setenv PATH ${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:$PATH
if ( $?EPICS_EXTENSIONS == 1 && -d ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH} ) then
    setenv PATH ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:$PATH
endif

# Set path to libraries provided by EPICS and its extensions (required by EPICS tools)
if ($?LD_LIBRARY_PATH == 0) then
    setenv LD_LIBRARY_PATH ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}
else
    setenv LD_LIBRARY_PATH ${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH
endif
if ($?EPICS_EXTENSIONS == 1 && -d ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}) then
    setenv LD_LIBRARY_PATH ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
endif

if ($?EPICS_EXTENSIONS == 1) then
	# Set EDMLIBS, used in $EDMOBJECTS/edmObjects and edmPvObjects
	setenv EDMLIBS ${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}

	# Set EDMHELPFILES
	if (-d "$EPICS_EXTENSIONS/helpFiles" ) then
		setenv EDMHELPFILES $EPICS_EXTENSIONS/helpFiles
	else
		setenv EDMHELPFILES $EPICS_EXTENSIONS/src/edm/helpFiles
	endif

	# The following could go to a one-time $EDMFILES/setup.sh
	setenv EDMWEBBROWSER mozilla
	#setenv EDMDATAFILES .
	setenv EDM ${TOOLS_SITE_TOP}/edm/display
	if ( -d ${TOOLS_SITE_TOP}/edm/config ) then
		setenv EDMFILES ${TOOLS_SITE_TOP}/edm/config
	else
		setenv EDMFILES ${EPICS_SITE_TOP}/tools/edm/config
	endif
	setenv EDMCALC ${EDMFILES}/calc.list
	setenv EDMOBJECTS $EDMFILES
	setenv EDMPVOBJECTS $EDMFILES
	setenv EDMFILTERS $EDMFILES
	setenv EDMUSERLIB $EDMLIBS
endif
