# This script provides access to our python 2.7 installation (this
# currently includes SIP, PyQt, numpy, Matplotlib and ipython)
if   [ -f  /reg/g/pcds/pyps/config/common_dirs.sh ]; then
    source /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -f  /afs/slac/g/pcds/config/common_dirs.sh ]; then
	source /afs/slac/g/pcds/config/common_dirs.sh
fi
if [ -z "$PSPKG_ROOT" ]; then
	export PSPKG_ROOT=/reg/g/pcds/pkg_mgr
fi

source $PSPKG_ROOT/etc/env_add_pkg.sh python/2.7.5

source $SETUP_SITE_TOP/pathmunge.sh
source $SETUP_SITE_TOP/lsb_family.sh

TCL_TK_DIR=$PSPKG_ROOT/release/tcl-tk/8.5.12/$PSPKG_ARCH
pathmunge $TCL_TK_DIR/bin
ldpathmunge $TCL_TK_DIR/lib
