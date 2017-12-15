# Reset for EPICS R3.14.12
# You just need to source this file and you
# are ready :)

# Define LCLS_ROOT, based on AFS for development or NFS for production

if [ -d /afs/slac/g/facet ]; then
        export FACET_ROOT=/afs/slac/g/facet
else
        export FACET_ROOT=/usr/local/facet
fi


export EPICS_BASE_VER=R3.15.5-1.0
export EPICS_EXTENSIONS_VER=R3.15.5
export EPICS_MODULES_VER=R3.15.5-1.0

source ${FACET_ROOT}/tools/script/ENVS_facet.bash

