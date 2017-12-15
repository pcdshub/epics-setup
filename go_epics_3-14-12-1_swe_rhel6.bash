# Reset for EPICS R3.14.12
# You just need to source this file and you
# are ready :)

# Define SWE_ROOT_RHEL6, based on AFS for development
if [ -d /afs/slac/g/cd/swe/rhel6 ]; then
        export SWE_ROOT_RHEL6=/afs/slac/g/cd/swe/rhel6
fi


export EPICS_BASE_VER=base-R3-14-12-1
export EPICS_EXTENSIONS_VER=R3-14-12-1
export EPICS_MODULES_VER=R3-14-12-1

source ${SWE_ROOT_RHEL6}/tools/script/ENVS_swe.bash


