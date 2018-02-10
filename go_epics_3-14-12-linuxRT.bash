# Reset for EPICS R3.14.12
# You just need to source this file and you
# are ready :)

# Define LCLS_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export LCLS_ROOT=/afs/slac/g/lcls
else
        export LCLS_ROOT=/usr/local/lcls
fi


export EPICS_BASE_VER=base-R3-14-12-linuxRT
export EPICS_EXTENSIONS_VER=R3-14-12
export EPICS_MODULES_VER=R3-14-12-linuxRT
export EPICS_MODULES_TOP=$EPICS_TOP/modules/${EPICS_MODULES_VER}

source ${LCLS_ROOT}/tools/script/ENVS.bash
export LD_LIBRARY_PATH=/usr/local/common/buildroot/buildroot-2012.02-x86/output/host/usr/lib:$LD_LIBRARY_PATH
