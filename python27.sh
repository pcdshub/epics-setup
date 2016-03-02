# This script provides access to our python 2.7 installation (this
# currently includes SIP, PyQt, numpy, Matplotlib and ipython)
if [ -z "$SETUP_SITE_TOP" ]; then
	export SETUP_SITE_TOP=/reg/g/pcds/setup
fi
#if [ -z "$PSPKG_ROOT" ]; then
export PSPKG_ROOT=/reg/common/package
#fi
source $SETUP_SITE_TOP/pathmunge.sh
source $SETUP_SITE_TOP/lsb_family.sh

if [ "$LSB_FAMILY" == "rhel6" ]; then
	pythondir=$PSPKG_ROOT/python/2.7.2-rhel6
else
	pythondir=$PSPKG_ROOT/python/2.7.2-rhel5
fi
pathmunge $pythondir/bin
ldpathmunge $pythondir/lib

