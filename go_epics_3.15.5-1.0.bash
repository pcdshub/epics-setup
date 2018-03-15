# =========================================
# Reset for EPICS R3-15
# You just need to source this file and you
# are ready :)
#
# -----------------------------------------
# Changelog
# 24-Nov-2014 Murali Shankar
#             Used go_epics_3-14-12-3_1-0.bash as the basis for go_epics_3-14-12-4_1-0.bash
# 10-Dec-2011 Ernest Williams
#             export EPICS_MODULES_TOP after sourcing ENVS.bash to define EPICS_TOP
# =========================================


# Define LCLS_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export LCLS_ROOT=/afs/slac/g/lcls
else
        export LCLS_ROOT=/usr/local/lcls
fi

# Override EPICS_TOP location
export EPICS_TOP=${LCLS_ROOT}/epics

export EPICS_BASE_VER=R3.15.5-1.0
export EPICS_EXTENSIONS_VER=R3.15.5
export EPICS_MODULES_VER=R3.15.5-1.0

export EPICS_BASE_TOP=${EPICS_TOP}/base
export EPICS_EXTENSIONS=${EPICS_TOP}/extensions
export EPICS_MODULES_TOP=${EPICS_TOP}/${EPICS_BASE_VER}/modules
export MOD=${EPICS_MODULES_TOP}
export EPICS_IOC_TOP=${EPICS_TOP}/iocTop

source ${LCLS_ROOT}/tools/script/ENVS_dev3.bash
export EPICS_MBA_TEMPLATE_TOP=${EPICS_MODULES_TOP}/icdTemplates/icdTemplates-R2-0-0

# ======================================================================
# Add Epics V4 Client Tools to the path
# ======================================================================
export PVACCESSCPP_MODULE_VERSION=R6.0.0-0.3.0
export PVACCESSCPP_HOME=${EPICS_MODULES_TOP}/pvAccessCPP/${PVACCESSCPP_MODULE_VERSION}
export PATH=${PVACCESSCPP_HOME}/bin/rhel6-x86_64:$PATH

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
# ================================================================================================

