# =========================================
# Reset for EPICS R3-14-12-4_1-0
# You just need to source this file and you
# are ready :)
#
# -----------------------------------------
# Changelog
# 31-Mar-2016 ababbitt - updated EPICS_MBA_TEMPLATE_TOP
# 24-Nov-2014 Murali Shankar
#             Used go_epics_3-14-12-3_1-0.bash as the basis for go_epics_3-14-12-4_1-0.bash
# 10-Dec-2011 Ernest Williams
#             export EPICS_MODULES_TOP after sourcing ENVS.bash to define EPICS_TOP
# =========================================
#
# Define LCLS_ROOT, based on AFS for development or NFS for production
if [ -d /afs/slac/g/lcls ]; then
        export LCLS_ROOT=/afs/slac/g/lcls
else
        export LCLS_ROOT=/usr/local/lcls
fi

# Override EPICS_TOP location
export EPICS_TOP=$LCLS_ROOT/epics/R3-14-12-4_1-0

export EPICS_BASE_VER=base-R3-14-12-4_1-0
export EPICS_EXTENSIONS_VER=R3-14-12
export EPICS_MODULES_VER=

export EPICS_BASE_TOP=$EPICS_TOP/base
export EPICS_EXTENSIONS=$EPICS_TOP/extensions-$EPICS_EXTENSIONS_VER
export EPICS_MODULES_TOP=${EPICS_TOP}/modules
export MOD=$EPICS_MODULES_TOP
export EPICS_IOC_TOP=${EPICS_TOP}/iocTop

source ${LCLS_ROOT}/tools/script/ENVS_dev3.bash
export EPICS_MBA_TEMPLATE_TOP=${EPICS_MODULES_TOP}/icdTemplates/icdTemplates-R1-2-1

# Alias to switch over to the new EPICS
alias newepics='source /afs/slac/g/lcls/epics/setup/go_epics_3-16-0.bash'

# ENV Variable for TFTP Server:
if [ -d $FACILITY_ROOT/tftpboot ]; then
 export TFTP_TOP=$FACILITY_ROOT/tftpboot
fi

# TOP for BuildRoot = linuxRT
if [ -d $FACILITY_ROOT/package/linux ]; then
 export LINUX_RT=$FACILITY_ROOT/package/linuxRT
fi

# setup for caQtDM: From PSI
if [ -f ${FACILITY_ROOT}/tools/caQtDM/script/caQtDMsetup.bash ]; then
 source ${FACILITY_ROOT}/tools/caQtDM/script/caQtDMsetup.bash
fi

# Override the standard python version
export PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/bin:$PATH
export LD_LIBRARY_PATH=$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib:$PACKAGE_TOP/python/python2.7.9/linux-x86_64/lib/python2.7/lib-dynload:$LD_LIBRARY_PATH

# End of script


