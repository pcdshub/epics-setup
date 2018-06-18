# Reset for EPICS R3.15.5-1.0 
# You just need to source this file and you
# are ready :)

# Define LCLS_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export LCLS_ROOT=/afs/slac/g/lcls
else
        export LCLS_ROOT=/usr/local/lcls
fi


export EPICS_BASE_VER=R3.15.5-1.0
export EPICS_EXTENSIONS_VER=R3.15.5-1.0
export EPICS_MODULES_VER=R3.15.5-1.0
export EPICS_MODULES_TOP=$EPICS_TOP/modules/${EPICS_MODULES_VER}

#source ${LCLS_ROOT}/tools/script/ENVS.bash
