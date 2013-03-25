# =========================================
# Reset for EPICS R3-14-12-3_1-0
# You just need to source this file and you
# are ready :)
#
# -----------------------------------------
# Changelog
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
export EPICS_TOP=$LCLS_ROOT/epics/R3-14-12-3_1-0

export EPICS_BASE_VER=base-R3-14-12-3_1-0
export EPICS_EXTENSIONS_VER=
export EPICS_MODULES_VER=

export EPICS_BASE_TOP=$EPICS_TOP/base
export EPICS_EXTENSIONS=$EPICS_TOP/extensions
export EPICS_MODULES_TOP=${EPICS_TOP}/modules
export EPICS_IOC_TOP=${EPICS_TOP}/iocTop

source ${LCLS_ROOT}/tools/script/ENVS.bash


export TEST_STAND=/afs/slac/g/lcls/epics/TestStand
