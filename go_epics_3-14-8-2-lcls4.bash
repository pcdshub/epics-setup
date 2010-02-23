# Reset for EPICS R3.14.8.2 lcls4 
# You just need to source this file and you
# are ready :)

# Define LCLS_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export LCLS_ROOT=/afs/slac/g/lcls
else
        export LCLS_ROOT=/usr/local/lcls
fi


export EPICS_BASE_VER=base-R3-14-8-2-lcls4
export EPICS_EXTENSIONS_VER=R3-14-8-2

source ${LCLS_ROOT}/tools/script/ENVS.bash

