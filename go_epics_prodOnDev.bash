# ==================================================
# 
# Name:  go_epics_3.14.12.5-1.0.bash
#
# Rem   Reset the epics environment to use
#       EPICS R3.14.12.5-1.0
#
# Usage: source <path>/go_epics-3.14.12.5-1.0.bash
# -------------------------------------------------
# Mod: 
#     23-Aug-2016,  B. Hill   (bhill)
#        Used go_epics-3.14.12.5-1.0.bash as starting point.
#        base R3.14.12.5-1.0 uses os specific target
#        architectures such as rhel6-x86_64 and also uses
#        a new version numbering scheme designed for
#        compatibility w/ all SLAC EPICS groups using the
#        same git repos.
#        Release names will follow the pattern:
#           R2.3.0-0.1.0
#        where 2.3.0 is the version from the upstream collaboration
#        and 0.1.0 is the local version number.
#        Local version numbers should be MAJOR.MINOR.DEP-ONLY
#        where the MAJOR number is for new features or major bug fixes,
#        MINOR is for minor bug fixes or changes, and DEP-ONLY
#        is for changes to just version dependencies, which would
#        typically be TOP/configure/RELEASE.local
#        
# ==================================================
#
# Determine which facility based on the host name 
# and the path. Only testfac and dev use afs, all
# other facilities use nfs. All production host have
# the facility in the host name. For instance, the
# hosts used by facet will have names such as facet-builder
# and facet-serv01, or facet-daemon01,etc.  
HOSTNAME=`hostname`
if [ -d /afs/slac/g/lcls ]; then
     if [[ $hostname == *"testfac-"* ]]; then
        export FACILITY=acctest
        export FACILITY_ROOT=/afs/slac/g/acctest
     else
        export FACILITY=dev
        export FACILITY_ROOT=/afs/slac/g/lcls
        export TFTP_TOP=${FACILITY_ROOT}/tftpboot
        export LINUXRT=$FACILITY_ROOT/package/linuxRT
     fi
elif [[ $hostname == *"facet-"* ]]; then
     if [ -d /usr/local/facet]; then
        export FACILITY=facet
        export FACILITY_ROOT=/usr/local/facet
        export TFTP_TOP=/usr/local/common/tftpboot
     else
        echo "Facility not supported on " $hostname
        exit 1
     fi
elif [[ $hostname == *"lcls-"* ]]; then
     if [ -d /usr/local/lcls]; then
        export FACILITY=lcls
        export FACILITY_ROOT=/usr/local/lcls
        export TFTP_TOP=/usr/local/common/tftpboot
     else
       echo "Facility not supported on " $hostname
        exit 1
     fi
else
   echo "Facility not supported on " $hostname
   exit 1
fi

# Override EPICS_TOP location
export EPICS_VER=R3.14.12.5-1.0
export EPICS_EXTENSIONS_VER=R3-14-12
export EPICS_MODULES_VER=
export EPICS_TOP=$FACILITY_ROOT/epics
export EPICS_BASE_VER=$EPICS_VER 
export EPICS_BASE_TOP=$EPICS_TOP/base
export EPICS_EXTENSIONS=$EPICS_TOP/extensions-$EPICS_EXTENSIONS_VER
export EPICS_MODULES_TOP=$EPICS_TOP/$EPICS_VER/modules
export MOD=$EPICS_MODULES_TOP
export EPICS_IOC_TOP=${EPICS_TOP}/iocTop
export LCLS_ROOT=$FACILITY_ROOT
export EPICS_MBA_TEMPLATE_TOP=${EPICS_MODULES_TOP}/icdTemplates/icdTemplates-R1-2-2

source ${FACILITY_ROOT}/tools/script/ENVS_dev3.bash
export EPICS_CA_ADDR_LIST; EPICS_CA_ADDR_LIST="lcls-prod01:5068 lcls-dev2:5066"

# Setup caQtDM display manager and runtime editor
# but only for development
if [ "$FACILITY" = "dev" ];then
  source ${FACILITY_ROOT}/tools/caQtDM/script/caQtDMsetup.bash
  # echo "caQtDM setup done"
fi

# Override the standard python version
export PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/bin:$PATH
export LD_LIBRARY_PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib:$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib/python2.7/lib-dynload:$LD_LIBRARY_PATH

# End of script

