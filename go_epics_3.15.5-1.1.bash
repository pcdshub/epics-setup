# =========================================
# Reset for EPICS R3.15.5-1.1
# You just need to source this file and you
# are ready :)
#
# -----------------------------------------
# Changelog
# 22-Feb-2019 K. Luchini 
#             go_epics_3.15.5-1.0.bash as the basis for go_epics_3.15.5-1.1.bash
# 24-Nov-2014 Murali Shankar
#             Used go_epics_3-14-12-3_1-0.bash as the basis for go_epics_3-14-12-4_1-0.bash
# 10-Dec-2011 Ernest Williams
#             export EPICS_MODULES_TOP after sourcing ENVS.bash to define EPICS_TOP
# =========================================


# Define FACILITY_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export FACILITY=Dev
        export FACILITY_ROOT=/afs/slac/g/lcls
else
        export FACILITY=lcls
        export FACILITY_ROOT=/usr/local/lcls
fi
export LCLS_ROOT=${FACILITY_ROOT}

# Override EPICS_TOP location
export EPICS_TOP=${FACILITY_ROOT}/epics

export EPICS_BASE_VER=R3.15.5-1.1
export EPICS_EXTENSIONS_VER=R3.15.5
export EPICS_MODULES_VER=R3.15.5-1.1

export EPICS_BASE_TOP=${EPICS_TOP}/base
export EPICS_EXTENSIONS=${EPICS_TOP}/extensions
export EPICS_MODULES_TOP=${EPICS_TOP}/${EPICS_BASE_VER}/modules
export MOD=${EPICS_MODULES_TOP}
export EPICS_IOC_TOP=${EPICS_TOP}/iocTop

source ${FACILITY_ROOT}/tools/script/ENVS_dev3.bash
export EPICS_MBA_TEMPLATE_TOP=${EPICS_MODULES_TOP}/icdTemplates/icdTemplates-R2-0-0

# ======================================================================
# Add Epics V4 Client Tools to the path
# ======================================================================
# Select EPICS V4 support modules (Not needed for BASE R7.0.0 or greater)
export PVACCESSCPP_MODULE_VERSION=R6.1.0-0.1.0
export PVACCESSCPP_HOME=${EPICS_MODULES_TOP}/pvAccessCPP/${PVACCESSCPP_MODULE_VERSION}
export PATH=${PVACCESSCPP_HOME}/bin/rhel6-x86_64:$PATH
export PVACCESSCPP=${EPICS_MODULES}/pvAccessCPP/${PVACCESSCPP_MODULE_VERSION}

# ======================================================================
# Setup for Octave
# ======================================================================
export OCTAVE=/afs/slac/g/lcls/package/octave
export OCTAVE_VER=octave-3.8.2
export OCTAVE_HOME=$OCTAVE/$OCTAVE_VER
export PATH=$OCTAVE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$OCTAVE_HOME/lib:$LD_LIBRARY_PATH
# ======================================================================

#=================================================================================================
# Setup Python Version 2.7.9: Overide the default
# ================================================================================================
export PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/bin:$PATH
#export PYTHONPATH=<location to other libraries not in site-packages>
export LD_LIBRARY_PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib:$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib/python2.7/lib-dynload:$LD_LIBRARY_PATH

export PYEPICS_LIBCA=$EPICS_BASE_TOP/$EPICS_BASE_VER/lib/$EPICS_HOST_ARCH/libca.so
export PYEPICS_LIBCOM=$EPICS_BASE_TOP/$EPICS_BASE_VER/lib/$EPICS_HOST_ARCH/libCom.so

# ================================================================================================

