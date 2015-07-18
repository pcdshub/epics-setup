# =========================================
# Reset for EPICS R3-14-12-4_1-0
# You just need to source this file and you
# are ready :)
#
# -----------------------------------------
# Changelog
# 24-Nov-2014 Murali Shankar
#             Used go_epics_3-14-12-3_1-0.bash as the basis for go_epics_3-14-12-4_1-0.bash
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
export EPICS_MBA_TEMPLATE_TOP=${EPICS_MODULES_TOP}/icdTemplates/icdTemplates-R1-2-0

# Alias to switch over to the new EPICS
alias newepics='source /afs/slac/g/lcls/epics/setup/go_epics_3-16-0.bash'

# ENV Variable for TFTP Server:
export TFTP_TOP=/afs/slac/g/lcls/tftpboot

# TOP for BuildRoot = linuxRT
export LINUX_RT=/afs/slac/g/lcls/package/linuxRT

# ===============================================================
# Let's setup for caQtDM: From PSI
# Display Editor and Manager for Control System GUI Development
# Both Editor/Runtime
# Using QT5 and QWT
# ==================================================
QTDIR=$PACKAGE_TOP/Qt-5.4.1
QTINC=$PACKAGE_TOP/Qt-5.4.1/include
QTLIB=$PACKAGE_TOP/Qt-5.4.1/lib
export QT_PLUGIN_PATH="${QTDIR}/plugins"
export PATH=$QTDIR/bin:$PATH
# ==================================================

# ============================================
# QWT Setup
# ============================================
export QWT_ROOT=$PACKAGE_TOP/qwt-6.1.2
export QT_PLUGIN_PATH="${QWT_ROOT}/plugins:$QT_PLUGIN_PATH"

# ==========================================================================================
# Plugin location for caQtDM and epicsQT
# ==========================================================================================
export QT_PLUGIN_PATH="${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:$QT_PLUGIN_PATH"
# ==========================================================================================


# ==========================================================================
# Where to search for caQtDM display files
# ==========================================================================
export CAQTDM_DISPLAY=$TOOLS/caQtDM/display
export CAQTDM_DISPLAY_PATH=$CAQTDM_DISPLAY/Tests:$CAQTDM_DISPLAY/iocAdmin
# ==========================================================================

# ================================================================
# Setup for EPICS QT (QE Framework) from Austraila:
# Using QT5
# ===============================================================
export QWT_INCLUDE_PATH=$QWT_ROOT/include
export QE_FFMPEG=YES
export QE_CAQTDM="${EPICS_EXTENSIONS}/src/caQtDM/caqtdm-devl_git"
export QE_CAQTDM_LIB=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}
export LD_LIBRARY_PATH=$QWT_ROOT/lib:$LD_LIBRARY_PATH
# ================================================================

