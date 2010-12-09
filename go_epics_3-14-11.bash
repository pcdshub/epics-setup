# Reset for EPICS R3.14.11
# You just need to source this file and you
# are ready :)

# Define LCLS_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export LCLS_ROOT=/afs/slac/g/lcls
else
        export LCLS_ROOT=/usr/local/lcls
fi


export EPICS_BASE_VER=base-R3-14-11
export EPICS_EXTENSIONS_VER=R3-14-11

source ${LCLS_ROOT}/tools/script/ENVS.bash

export TEST_STAND=/afs/slac/g/lcls/epics/TestStand
