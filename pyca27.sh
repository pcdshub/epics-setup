# This script provides access to the EPICS libraries required by our
# local implementation (pyca) of an EPICS python client
if   [ -f  /reg/g/pcds/pyps/config/common_dirs.sh ]; then
    source /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -f  /afs/slac/g/pcds/config/common_dirs.sh ]; then
	source /afs/slac/g/pcds/config/common_dirs.sh
fi

source $SETUP_SITE_TOP/pathmunge.sh
source $SETUP_SITE_TOP/lsb_family.sh

if [ "$LSB_FAMILY" == "rhel6" ]; then
	PYCA_LIB=$PSPKG_ROOT/release/pyca/2.1.0-python2.7/x86_64-rhel6-gcc44-opt/lib
else
	PYCA_LIB=$PSPKG_ROOT/release/pyca/2.1.0-python2.7/x86_64-rhel5-gcc41-opt/lib
fi
pythonpathmunge $PYCA_LIB/python2.7/site-packages

#pythonpathmunge /reg/g/pcds/pds/pyca
#pythonpathmunge /reg/g/pcds/controls

if [ -z "$EPICS_CA_MAX_ARRAY_BYTES" ]; then
	export EPICS_CA_MAX_ARRAY_BYTES=8000000
fi
