# Reset for EPICS R3.14.12.1
# You just need to source this file and you
# are ready :)

# Define SWE_ROOT, based on AFS for development
if [ -d /afs/slac/g/cd/swe/rhel5 ]; then
        export SWE_ROOT=/afs/slac/g/cd/swe/rhel5
fi


export EPICS_BASE_VER=base-R3-14-12-1
export EPICS_EXTENSIONS_VER=R3-14-12-1
export EPICS_MODULES_VER=R3-14-12-1

source ${SWE_ROOT}/tools/script/ENVS_swe.bash


